"""Regression tests for issue #89 (session-start injection diet).

SessionStart previously injected the full ``_index.yaml`` — 39KB+ on a
mature world, scaling with walnut count, mostly metadata the model can
read on demand. The hook now injects a brief built from ``_index.json``:
walnut names, paths and phases grouped by domain, people names, recent
sessions and counts. Goals, tags and capsule lists stay on disk.

The hook regenerates the index synchronously at session start, so these
tests build real walnut directories and let the generator produce the
index the brief is derived from. (The full-index fallback for worlds
where ``_index.json`` cannot be produced is a code path, not covered
here — it requires a python3-less environment.)
"""

from __future__ import annotations

import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PLUGIN = ROOT / "plugins" / "alive"
HOOKS = PLUGIN / "hooks" / "scripts"


def run_session_new(world: Path, session_id: str) -> str:
    payload = {
        "session_id": session_id,
        "cwd": str(world),
        "hook_event_name": "SessionStart",
        "model": "test-model",
        "source": "startup",
        "transcript_path": str(world / "transcript.jsonl"),
    }
    env = os.environ.copy()
    env.update(
        {
            "ALIVE_WORLD_ROOT_OVERRIDE": str(world),
            "CLAUDE_PLUGIN_ROOT": str(PLUGIN),
            "CLAUDE_ENV_FILE": str(world / ".claude-env"),
        }
    )
    result = subprocess.run(
        ["bash", str(HOOKS / "alive-session-new.sh")],
        input=json.dumps(payload),
        text=True,
        capture_output=True,
        cwd=world,
        env=env,
    )
    output = json.loads(result.stdout)
    return output["hookSpecificOutput"]["additionalContext"]


def write_walnut(root: Path, rel: str, goal: str, phase: str = "building") -> None:
    kernel = root / rel / "_kernel"
    kernel.mkdir(parents=True)
    (kernel / "key.md").write_text(
        "---\n"
        "type: venture\n"
        f"goal: {goal}\n"
        "created: 2026-09-01\n"
        "rhythm: weekly\n"
        "tags: [tag-not-injected]\n"
        "---\n",
        encoding="utf-8",
    )
    (kernel / "now.json").write_text(
        json.dumps({"phase": phase, "squirrel": "someone"}), encoding="utf-8"
    )


class SessionStartBriefTest(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.world = Path(self._tmp.name) / "world"
        (self.world / ".alive" / "_squirrels").mkdir(parents=True)
        (self.world / ".alive" / "preferences.yaml").write_text(
            "github_star_ask: false\n", encoding="utf-8"
        )
        (self.world / "03_Inbox").mkdir()
        write_walnut(self.world, "04_Ventures/my-venture", "SECRET-GOAL-TEXT here")
        write_walnut(
            self.world, "01_Archive/04_Ventures/old-thing", "archived goal", "dead"
        )
        person = self.world / "02_Life" / "people" / "jane-doe" / "_kernel"
        person.mkdir(parents=True)
        (person / "key.md").write_text(
            "---\ntype: person\ngoal: knows things\n---\n", encoding="utf-8"
        )

    def tearDown(self) -> None:
        self._tmp.cleanup()

    def test_brief_injected_with_registry_but_no_metadata(self) -> None:
        context = run_session_new(self.world, "brief-test-1")

        self.assertIn("<WORLD_INDEX_BRIEF>", context)
        self.assertIn("my-venture", context)
        self.assertIn("04_Ventures/my-venture", context)
        self.assertIn("jane-doe", context)
        # metadata stays on disk, one read away
        self.assertNotIn("SECRET-GOAL-TEXT", context)
        self.assertNotIn("tag-not-injected", context)
        # archived walnuts are counted, not listed
        self.assertNotIn("01_Archive/04_Ventures/old-thing", context)
        # the full index is no longer injected
        self.assertNotIn("<WORLD_INDEX>\n", context)
        # and it still exists on disk for on-demand reads
        self.assertTrue((self.world / ".alive" / "_index.yaml").exists())

    def test_brief_is_materially_smaller_than_full_index(self) -> None:
        context = run_session_new(self.world, "brief-test-2")
        start = context.index("<WORLD_INDEX_BRIEF>")
        end = context.index("</WORLD_INDEX_BRIEF>")
        brief_size = end - start
        full_size = (self.world / ".alive" / "_index.yaml").stat().st_size
        self.assertLess(brief_size, full_size)


if __name__ == "__main__":
    unittest.main()
