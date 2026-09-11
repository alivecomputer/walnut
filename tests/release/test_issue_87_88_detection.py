"""Regression tests for issues #87 and #88.

Issue #87: walnut resolution walked the whole world with find on every
prompt (killed by the 5s hook timeout on large worlds), could not parse
quoted or path-form ``walnut:`` values from session records, and could
resolve into archived copies via first-basename-match.

Issue #88: the cross-session unsaved-stash awareness (ACTIVE_SQUIRRELS)
was removed with #86 because it was chained to the context-% trigger;
re-homed here on a change-driven trigger — detailed for same-walnut
sessions, a one-line count for others.
"""

from __future__ import annotations

import json
import os
import subprocess
import tempfile
import unittest
import uuid
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PLUGIN = ROOT / "plugins" / "alive"
HOOKS = PLUGIN / "hooks" / "scripts"


def run_context_watch(world: Path, session_id: str) -> subprocess.CompletedProcess[str]:
    payload = {
        "session_id": session_id,
        "cwd": str(world),
        "hook_event_name": "UserPromptSubmit",
    }
    env = os.environ.copy()
    env.update(
        {
            "ALIVE_WORLD_ROOT_OVERRIDE": str(world),
            "CLAUDE_PLUGIN_ROOT": str(PLUGIN),
        }
    )
    return subprocess.run(
        ["bash", str(HOOKS / "alive-context-watch.sh")],
        input=json.dumps(payload),
        text=True,
        capture_output=True,
        cwd=world,
        env=env,
    )


def context_of(result: subprocess.CompletedProcess[str]) -> str:
    if not result.stdout.strip():
        return ""
    return json.loads(result.stdout)["hookSpecificOutput"]["additionalContext"]


class DetectionTestCase(unittest.TestCase):
    """Shared world scaffolding with tmp-file cleanup."""

    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.world = Path(self._tmp.name) / "world"
        (self.world / ".alive" / "_squirrels").mkdir(parents=True)
        (self.world / ".alive" / "preferences.yaml").write_text(
            "github_star_ask: false\n", encoding="utf-8"
        )
        self.session_id = f"issue87-{uuid.uuid4().hex[:12]}"

    def tearDown(self) -> None:
        tmpdir = Path(os.environ.get("TMPDIR", "/tmp"))
        for prefix in ("alive-lastcheck-", "alive-walnutdir-", "alive-squirrelstamp-"):
            (tmpdir / f"{prefix}{self.session_id}").unlink(missing_ok=True)
        self._tmp.cleanup()

    def make_walnut(self, rel: str, squirrel: str = "another-session") -> Path:
        kernel = self.world / rel / "_kernel"
        kernel.mkdir(parents=True)
        (kernel / "now.json").write_text(
            json.dumps({"phase": "testing", "squirrel": squirrel}), encoding="utf-8"
        )
        return self.world / rel

    def claim_session(self, walnut_value: str, session_id: str | None = None,
                      stash: list[str] | None = None) -> None:
        sid = session_id or self.session_id
        lines = [
            f"session_id: {sid}",
            f"walnut: {walnut_value}",
            "saves: 0",
            "ended: null",
        ]
        if stash:
            lines.append("stash:")
            for item in stash:
                lines.append(f'  - content: "{item}"')
        (self.world / ".alive" / "_squirrels" / f"{sid}.yaml").write_text(
            "\n".join(lines) + "\n", encoding="utf-8"
        )

    def write_index(self, entries: list[tuple[str, str]]) -> None:
        walnuts = {
            name: {"name": name, "path": path} for name, path in entries
        }
        (self.world / ".alive" / "_index.json").write_text(
            json.dumps({"walnuts": walnuts, "people": {}}), encoding="utf-8"
        )

    def detect_change(self) -> str:
        """First run to stamp, bump mtime, second run; returns message."""
        first = run_context_watch(self.world, self.session_id)
        self.assertEqual(first.returncode, 0, first.stderr)
        now_json = next((self.world).rglob("now.json"))
        future = now_json.stat().st_mtime + 5
        os.utime(now_json, (future, future))
        second = run_context_watch(self.world, self.session_id)
        self.assertEqual(second.returncode, 0, second.stderr)
        return context_of(second)


class WalnutResolutionTest(DetectionTestCase):
    def test_quoted_path_form_value_resolves(self) -> None:
        self.make_walnut("05_Experiments/test-walnut")
        self.write_index([("test-walnut", "05_Experiments/test-walnut")])
        self.claim_session('"05_Experiments/test-walnut"')

        message = self.detect_change()

        self.assertIn("Another session just saved", message)
        self.assertIn("now.json", message)

    def test_bare_name_resolves_via_index(self) -> None:
        self.make_walnut("04_Ventures/lab/deep-walnut")
        self.write_index([("deep-walnut", "04_Ventures/lab/deep-walnut")])
        self.claim_session("deep-walnut")

        message = self.detect_change()

        self.assertIn("Another session just saved", message)

    def test_archived_duplicate_not_preferred(self) -> None:
        self.make_walnut("05_Experiments/dupe")
        archived = self.world / "01_Archive" / "05_Experiments" / "dupe" / "_kernel"
        archived.mkdir(parents=True)
        (archived / "now.json").write_text(
            json.dumps({"squirrel": "x"}), encoding="utf-8"
        )
        self.write_index(
            [("dupe", "05_Experiments/dupe")]
        )
        # index also carries the archived copy under a distinct key
        index = json.loads((self.world / ".alive" / "_index.json").read_text())
        index["walnuts"]["dupe-archived"] = {
            "name": "dupe",
            "path": "01_Archive/05_Experiments/dupe",
        }
        (self.world / ".alive" / "_index.json").write_text(json.dumps(index))
        self.claim_session("dupe")

        run_context_watch(self.world, self.session_id)

        tmpdir = Path(os.environ.get("TMPDIR", "/tmp"))
        cached = (tmpdir / f"alive-walnutdir-{self.session_id}").read_text().strip()
        self.assertEqual(cached, "05_Experiments/dupe")

    def test_no_index_falls_back_to_find(self) -> None:
        self.make_walnut("05_Experiments/findable")
        self.claim_session("findable")

        message = self.detect_change()

        self.assertIn("Another session just saved", message)


class CrossSessionAwarenessTest(DetectionTestCase):
    def test_same_walnut_stash_is_detailed(self) -> None:
        self.make_walnut("05_Experiments/shared", squirrel=self.session_id[:8])
        self.write_index([("shared", "05_Experiments/shared")])
        self.claim_session("shared")
        self.claim_session(
            "shared",
            session_id=f"other-{uuid.uuid4().hex[:8]}",
            stash=["decided to use path-canonical references"],
        )

        result = run_context_watch(self.world, self.session_id)
        message = context_of(result)

        self.assertIn("unsaved stash", message)
        self.assertIn("path-canonical", message)

    def test_other_walnut_is_count_line_only(self) -> None:
        self.make_walnut("05_Experiments/mine", squirrel=self.session_id[:8])
        self.make_walnut("05_Experiments/elsewhere", squirrel="zz")
        self.write_index(
            [("mine", "05_Experiments/mine"), ("elsewhere", "05_Experiments/elsewhere")]
        )
        self.claim_session("mine")
        self.claim_session(
            "elsewhere",
            session_id=f"other-{uuid.uuid4().hex[:8]}",
            stash=["secret detail that must not be injected"],
        )

        result = run_context_watch(self.world, self.session_id)
        message = context_of(result)

        self.assertIn("Other active sessions with unsaved work", message)
        self.assertIn("elsewhere", message)
        self.assertNotIn("secret detail", message)

    def test_unchanged_squirrels_do_not_reannounce(self) -> None:
        self.make_walnut("05_Experiments/quiet", squirrel=self.session_id[:8])
        self.write_index([("quiet", "05_Experiments/quiet")])
        self.claim_session("quiet")
        self.claim_session(
            "quiet",
            session_id=f"other-{uuid.uuid4().hex[:8]}",
            stash=["announced once"],
        )

        first = run_context_watch(self.world, self.session_id)
        self.assertIn("announced once", context_of(first))

        second = run_context_watch(self.world, self.session_id)
        self.assertEqual(context_of(second), "")


if __name__ == "__main__":
    unittest.main()
