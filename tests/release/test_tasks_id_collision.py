"""Regression tests for the tasks.py id-collision data loss (t140).

Pre-fix v2->v3 migration assigned ids from a counter starting at 1
with no awareness of ids already in the file, so mixed v2/v3 files got
duplicate ids. ``cmd_done``/``cmd_drop`` then removed tasks with an id
FILTER — deleting every task sharing the id in one call — while
``_find_task`` resolved only the first match, so ``completed.json``
recorded one task and the rest vanished with no record anywhere.
Observed in production: 8 tasks silently deleted from a real walnut
(recovered only via a pre-mutation snapshot), ~48 more live collisions
found across two other walnuts.

Pins: mutation on an ambiguous id refuses and exits 2 with both tasks
intact; mutation on a unique id removes exactly that task; migration
of a mixed file continues ids after the file's high-water mark.
"""

from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
TASKS = ROOT / "plugins" / "alive" / "scripts" / "tasks.py"


def run_tasks(walnut: Path, *args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(TASKS), *args, "--walnut", str(walnut)],
        text=True,
        capture_output=True,
    )


def make_walnut(base: Path, tasks: list[dict]) -> Path:
    walnut = base / "walnut"
    kernel = walnut / "_kernel"
    kernel.mkdir(parents=True)
    (kernel / "key.md").write_text("# key\n", encoding="utf-8")
    (kernel / "tasks.json").write_text(
        json.dumps({"tasks": tasks}), encoding="utf-8"
    )
    return walnut


def v3_task(tid: str, title: str) -> dict:
    return {
        "id": tid,
        "title": title,
        "status": "todo",
        "priority": "todo",
        "assignee": None,
        "due": None,
        "tags": [],
        "created": "2026-09-01",
        "session": "test",
    }


class AmbiguousIdRefusalTest(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.walnut = make_walnut(
            Path(self._tmp.name),
            [
                v3_task("t001", "live task that must survive"),
                v3_task("t002", "unique task"),
                v3_task("t001", "stale duplicate from migration"),
            ],
        )

    def tearDown(self) -> None:
        self._tmp.cleanup()

    def read_tasks(self) -> list[dict]:
        data = json.loads(
            (self.walnut / "_kernel" / "tasks.json").read_text(encoding="utf-8")
        )
        return data["tasks"]

    def test_done_on_duplicate_id_refuses_and_loses_nothing(self) -> None:
        result = run_tasks(self.walnut, "done", "--id", "t001")

        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertIn("share id t001", result.stderr)
        remaining = self.read_tasks()
        self.assertEqual(len(remaining), 3, "no task may be removed on refusal")
        completed = self.walnut / "_kernel" / "completed.json"
        if completed.exists():
            data = json.loads(completed.read_text(encoding="utf-8"))
            self.assertEqual(data.get("completed", []), [])

    def test_drop_on_duplicate_id_refuses_and_loses_nothing(self) -> None:
        result = run_tasks(self.walnut, "drop", "--id", "t001")

        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertEqual(len(self.read_tasks()), 3)

    def test_edit_on_duplicate_id_refuses(self) -> None:
        result = run_tasks(
            self.walnut, "edit", "--id", "t001", "--priority", "urgent"
        )

        self.assertEqual(result.returncode, 2, result.stderr)
        for task in self.read_tasks():
            self.assertNotEqual(
                task.get("priority"), "urgent", "no task may be edited on refusal"
            )

    def test_done_on_unique_id_removes_exactly_one(self) -> None:
        result = run_tasks(self.walnut, "done", "--id", "t002")

        self.assertEqual(result.returncode, 0, result.stderr)
        remaining = self.read_tasks()
        self.assertEqual(len(remaining), 2)
        self.assertTrue(all(t["id"] == "t001" for t in remaining))
        completed = json.loads(
            (self.walnut / "_kernel" / "completed.json").read_text(encoding="utf-8")
        )
        self.assertEqual(len(completed["completed"]), 1)
        self.assertEqual(completed["completed"][0]["title"], "unique task")


class MigrationRekeyTest(unittest.TestCase):
    def test_mixed_file_migration_continues_after_high_water_mark(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            walnut = make_walnut(
                Path(tmp),
                [
                    v3_task("t001", "existing v3 one"),
                    v3_task("t007", "existing v3 with high id"),
                    {"text": "legacy v2 task A", "status": "todo", "priority": "normal"},
                    {"text": "legacy v2 task B", "status": "todo", "priority": "urgent"},
                ],
            )

            # Any list invocation triggers the in-place upgrade.
            result = run_tasks(walnut, "list")
            self.assertEqual(result.returncode, 0, result.stderr)

            data = json.loads(
                (walnut / "_kernel" / "tasks.json").read_text(encoding="utf-8")
            )
            ids = [t["id"] for t in data["tasks"]]
            self.assertEqual(
                len(ids), len(set(ids)), f"migration produced duplicate ids: {ids}"
            )
            self.assertIn("t008", ids)
            self.assertIn("t009", ids)


if __name__ == "__main__":
    unittest.main()
