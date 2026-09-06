#!/usr/bin/env python3
"""Behavioral tests for the distributable agent kit (standard library only)."""
from pathlib import Path
import os
import stat
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
INSTALLER = ROOT / "universal-project-agent-template/install.sh"


def run(*args, cwd=ROOT, check=True, env=None):
    return subprocess.run(args, cwd=cwd, check=check, text=True,
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          env=env)


class AgentKitTest(unittest.TestCase):
    def test_full_install_and_checker_use_installed_root(self):
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / "project"
            run(str(INSTALLER), "--target", str(target), "--mode", "new",
                "--profile", "full", "--apply")
            unrelated = Path(tmp) / "unrelated"
            unrelated.mkdir()
            result = run(str(target / "scripts/check-agent-kit.sh"), cwd=unrelated)
            self.assertIn("passed", result.stdout)
            self.assertTrue((target / "scripts/run-github-mcp.sh").stat().st_mode & stat.S_IXUSR)
            # Installed project configuration is user-owned and is never echoed
            # or rejected by a template-source policy check.
            (target / ".codex/config.toml").write_text("[mcp_servers.local]\nenabled=true\n")
            result = run(str(target / "scripts/check-agent-kit.sh"), cwd=unrelated)
            self.assertIn("passed", result.stdout)

    def test_existing_conflicting_script_content_and_mode_are_preserved(self):
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / "project"
            scripts = target / "scripts"
            scripts.mkdir(parents=True)
            existing = scripts / "agent-start.sh"
            existing.write_text("existing\n")
            existing.chmod(0o600)
            unrelated = scripts / "private.sh"
            unrelated.write_text("private\n")
            unrelated.chmod(0o640)
            run(str(INSTALLER), "--target", str(target), "--mode", "existing",
                "--profile", "recommended", "--apply")
            self.assertEqual(existing.read_text(), "existing\n")
            self.assertEqual(stat.S_IMODE(existing.stat().st_mode), 0o600)
            self.assertEqual(stat.S_IMODE(unrelated.stat().st_mode), 0o640)
            self.assertTrue((scripts / "agent-finish.sh").stat().st_mode & stat.S_IXUSR)

    def test_symlink_destination_cannot_escape_target(self):
        for shape in ("child", "target", "ancestor"):
            with self.subTest(shape=shape), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp)
                outside = root / "outside"
                outside.mkdir()
                if shape == "child":
                    target = root / "project"
                    target.mkdir()
                    (target / "docs").symlink_to(outside, target_is_directory=True)
                elif shape == "target":
                    target = root / "project"
                    target.symlink_to(outside, target_is_directory=True)
                else:
                    link = root / "link"
                    link.symlink_to(outside, target_is_directory=True)
                    target = link / "project"
                result = run(str(INSTALLER), "--target", str(target), "--mode", "new",
                             "--profile", "core", "--apply", check=False)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(list(outside.iterdir()), [])
        result = run(str(INSTALLER), "--target", "/", "--mode", "existing",
                     "--profile", "core", "--dry-run", check=False)
        self.assertNotEqual(result.returncode, 0)

    def test_checker_rejects_incomplete_frontmatter_and_fence(self):
        for mutation in ("frontmatter", "fence"):
            with self.subTest(mutation=mutation), tempfile.TemporaryDirectory() as tmp:
                target = Path(tmp) / "project"
                run(str(INSTALLER), "--target", str(target), "--mode", "new",
                    "--profile", "recommended", "--apply")
                skill = target / ".agents/skills/capability-router/SKILL.md"
                if mutation == "frontmatter":
                    skill.write_text("---\nname: capability-router\ndescription: broken\n")
                else:
                    skill.write_text(skill.read_text() + "\n```text\nunclosed\n")
                result = run(str(target / "scripts/check-agent-kit.sh"), check=False)
                self.assertNotEqual(result.returncode, 0)

    def test_pr_validator_accepts_filled_template_and_rejects_missing_sections(self):
        template = ROOT / ".github/pull_request_template.md"
        text = template.read_text()
        text = text.replace("Closes #", "Closes #7")
        for marker in ("\n-\n",):
            text = text.replace(marker, "\n- Verified value.\n")
        text = text.replace("- [ ]", "- [x]")
        with tempfile.TemporaryDirectory() as tmp:
            body = Path(tmp) / "body.md"
            body.write_text(text)
            run("python3", "scripts/validate-pr-body.py", "--body", str(body))
            headings = [line[3:] for line in text.splitlines() if line.startswith("## ")]
            for heading in headings:
                broken = text.replace("## " + heading, "### " + heading, 1)
                body.write_text(broken)
                result = run("python3", "scripts/validate-pr-body.py", "--body",
                             str(body), check=False)
                self.assertNotEqual(result.returncode, 0, heading)
            body.write_text(text.replace("- [x]", "- [ ]", 1))
            result = run("python3", "scripts/validate-pr-body.py", "--body",
                         str(body), check=False)
            self.assertNotEqual(result.returncode, 0, "unchecked checklist")

    def test_start_creates_fresh_worktree_without_switching_dirty_main(self):
        with tempfile.TemporaryDirectory() as tmp:
            remote = Path(tmp) / "remote.git"
            seed = Path(tmp) / "seed"
            worktrees = Path(tmp) / "worktrees"
            run("git", "init", "--bare", str(remote))
            run("git", "init", "-b", "main", str(seed))
            run("git", "config", "user.email", "test@example.invalid", cwd=seed)
            run("git", "config", "user.name", "Test", cwd=seed)
            (seed / "tracked").write_text("base\n")
            run("git", "add", "tracked", cwd=seed); run("git", "commit", "-m", "base", cwd=seed)
            run("git", "remote", "add", "origin", str(remote), cwd=seed)
            run("git", "push", "-u", "origin", "main", cwd=seed)
            (seed / "tracked").write_text("dirty\n")
            env = dict(os.environ, AGENT_WORKTREE_ROOT=str(worktrees))
            run(str(ROOT / "scripts/agent-start.sh"), "7", "safe-start", cwd=seed, env=env)
            self.assertEqual(run("git", "branch", "--show-current", cwd=seed).stdout.strip(), "main")
            self.assertEqual((seed / "tracked").read_text(), "dirty\n")
            task = worktrees / "wt-issue-7-safe-start"
            self.assertEqual((task / "tracked").read_text(), "base\n")

    def test_ci_contract_is_scoped_and_uses_the_real_pr_validator(self):
        ci = (ROOT / ".github/workflows/ci.yml").read_text()
        self.assertIn("github.event.pull_request.number || github.ref", ci)
        self.assertIn("github.event_name == 'pull_request'", ci)
        hygiene = (ROOT / ".github/workflows/pr-hygiene.yml").read_text()
        self.assertIn("scripts/validate-pr-body.py --body -", hygiene)
        self.assertIn("persist-credentials: false", hygiene)
        self.assertNotIn("required_sections=", hygiene)

    def test_github_context_requires_matching_explicit_token_actor_and_repository(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            repository = root / "project"
            fake_bin = root / "bin"
            repository.mkdir(); fake_bin.mkdir()
            run("git", "init", "-b", "main", cwd=repository)
            run("git", "remote", "add", "origin",
                "https://github.com/acme/example.git", cwd=repository)
            fake_gh = fake_bin / "gh"
            fake_gh.write_text(
                "#!/usr/bin/env bash\n"
                "[ \"$*\" = \"api user --jq .login\" ] && printf 'worker\\n'\n"
            )
            fake_gh.chmod(0o700)
            context = ROOT / "scripts/check-github-context.sh"
            base_env = dict(
                os.environ,
                PATH=str(fake_bin) + os.pathsep + os.environ["PATH"],
                AGENT_GITHUB_TOKEN="synthetic-token",
                AGENT_GITHUB_ACTOR="worker",
                AGENT_GITHUB_REPOSITORY="acme/example",
            )
            result = run(str(context), cwd=repository, env=base_env)
            self.assertNotIn("synthetic-token", result.stdout + result.stderr)
            for key, value in (
                ("AGENT_GITHUB_ACTOR", "other"),
                ("AGENT_GITHUB_REPOSITORY", "other/example"),
            ):
                result = run(str(context), cwd=repository,
                             env=dict(base_env, **{key: value}), check=False)
                self.assertNotEqual(result.returncode, 0)

    def test_mcp_does_not_derive_an_ambient_gh_token(self):
        packaged_config = (ROOT / "universal-project-agent-template/modules/mcp/.codex/config.toml").read_text()
        repository_config = (ROOT / ".codex/config.toml").read_text()
        registry = (ROOT / "docs/mcp-registry.md").read_text()
        combined = packaged_config + repository_config + registry
        self.assertNotIn("gh auth token", combined)
        self.assertIn("AGENT_GITHUB_REPOSITORY", combined)
        for config in (packaged_config, repository_config):
            self.assertIn("scripts/run-github-mcp.sh", config)
            self.assertNotIn('command = "docker"', config)

    def test_finish_uses_explicit_github_identity_for_push_and_pr(self):
        finish = (ROOT / "scripts/agent-finish.sh").read_text()
        self.assertIn('GIT_ASKPASS="$ROOT/scripts/github-askpass.sh"', finish)
        self.assertIn('GIT_TERMINAL_PROMPT=0', finish)
        self.assertIn('git -c credential.helper= push "$PUSH_URL"', finish)
        self.assertNotIn('git push -u origin', finish)
        self.assertIn('GH_TOKEN="$AGENT_GITHUB_TOKEN" gh pr create', finish)
        self.assertIn('if [ -n "$MODE" ]', finish)
        self.assertIn('--run-validation', finish)

        helper = ROOT / "scripts/github-askpass.sh"
        env = dict(
            os.environ,
            AGENT_GITHUB_TOKEN="synthetic-token",
            AGENT_GITHUB_ACTOR="explicit-worker",
        )
        actor = run(str(helper), "Username for github.com", env=env)
        token = run(str(helper), "Password for github.com", env=env)
        self.assertEqual(actor.stdout.strip(), "explicit-worker")
        self.assertEqual(token.stdout.strip(), "synthetic-token")

        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            repository = root / "project"
            fake_bin = root / "bin"
            make_log = root / "make-called"
            fake_bin.mkdir()
            run(str(INSTALLER), "--target", str(repository), "--mode", "new",
                "--profile", "full", "--apply")
            run("git", "init", "-b", "agent/test", cwd=repository)
            run("git", "config", "user.email", "test@example.invalid", cwd=repository)
            run("git", "config", "user.name", "Test", cwd=repository)
            run("git", "remote", "add", "origin",
                "https://github.com/acme/example.git", cwd=repository)
            run("git", "add", ".", cwd=repository)
            run("git", "commit", "-m", "initial", cwd=repository)
            body = root / "body.md"
            body_text = (repository / ".github/pull_request_template.md").read_text()
            body_text = body_text.replace("Closes #", "Closes #7")
            body_text = body_text.replace("\n-\n", "\n- Verified value.\n")
            body_text = body_text.replace("- [ ]", "- [x]")
            body.write_text(body_text)
            fake_make = fake_bin / "make"
            fake_make.write_text(
                "#!/usr/bin/env bash\n"
                "printf called > \"$MAKE_CALL_LOG\"\n"
                "exit 88\n"
            )
            fake_make.chmod(0o700)
            finish_env = dict(
                os.environ,
                PATH=str(fake_bin) + os.pathsep + os.environ["PATH"],
                MAKE_CALL_LOG=str(make_log),
            )
            result = run(str(repository / "scripts/agent-finish.sh"), "7",
                         "--body-file", str(body), cwd=repository,
                         env=finish_env, check=False)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(make_log.exists())
            result = run(str(repository / "scripts/agent-finish.sh"), "7",
                         "--body-file", str(body), "--run-validation", "docs",
                         cwd=repository, env=finish_env, check=False)
            self.assertEqual(result.returncode, 88)
            self.assertTrue(make_log.exists())

    def test_label_setup_uses_the_same_explicit_github_context(self):
        labels = (ROOT / "scripts/setup-github-labels.sh").read_text()
        self.assertIn('scripts/check-github-context.sh', labels)
        self.assertIn('GH_TOKEN="$AGENT_GITHUB_TOKEN" gh api', labels)
        self.assertIn('repos/${AGENT_GITHUB_REPOSITORY}', labels)
        self.assertNotIn('gh auth status', labels)
        self.assertNotIn('repos/{owner}/{repo}', labels)

        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            repository = root / "project"
            fake_bin = root / "bin"
            call_log = root / "gh-calls"
            fake_bin.mkdir()
            run(str(INSTALLER), "--target", str(repository), "--mode", "new",
                "--profile", "full", "--apply")
            run("git", "init", "-b", "main", cwd=repository)
            run("git", "remote", "add", "origin",
                "https://github.com/acme/example.git", cwd=repository)
            fake_gh = fake_bin / "gh"
            fake_gh.write_text(
                "#!/usr/bin/env bash\n"
                "[ \"${GH_TOKEN:-}\" = synthetic-token ] || exit 21\n"
                "if [ \"$*\" = \"api user --jq .login\" ]; then\n"
                "  printf 'worker\\n'\n"
                "  exit 0\n"
                "fi\n"
                "printf '%s\\n' \"$*\" >> \"$GH_CALL_LOG\"\n"
            )
            fake_gh.chmod(0o700)
            env = dict(
                os.environ,
                PATH=str(fake_bin) + os.pathsep + os.environ["PATH"],
                GH_CALL_LOG=str(call_log),
                AGENT_GITHUB_TOKEN="synthetic-token",
                AGENT_GITHUB_ACTOR="worker",
                AGENT_GITHUB_REPOSITORY="acme/example",
            )
            result = run(str(repository / "scripts/setup-github-labels.sh"),
                         cwd=repository, env=env)
            self.assertNotIn("synthetic-token", result.stdout + result.stderr)
            calls = call_log.read_text().splitlines()
            self.assertTrue(calls)
            self.assertTrue(all("repos/acme/example/labels" in call for call in calls))

    def test_sync_state_preserves_manual_notes(self):
        with tempfile.TemporaryDirectory() as tmp:
            umbrella = Path(tmp) / "umbrella"
            repository = umbrella / "project"
            repository.mkdir(parents=True)
            run("git", "init", "-b", "main", cwd=repository)
            state = umbrella / "STATE.md"
            sync = ROOT / "scripts/sync-state.sh"
            run(str(sync), cwd=repository)
            first = state.read_text()
            state.write_text(first.replace(
                "<!-- BEGIN MANUAL NOTES -->\n",
                "<!-- BEGIN MANUAL NOTES -->\n- Keep this manual decision.\n",
            ))
            run(str(sync), cwd=repository)
            refreshed = state.read_text()
            self.assertIn("- Keep this manual decision.", refreshed)
            self.assertEqual(refreshed.count("<!-- BEGIN MANUAL NOTES -->"), 1)
            self.assertEqual(refreshed.count("<!-- END MANUAL NOTES -->"), 1)
            malformed = "# STATE.md\n<!-- BEGIN MANUAL NOTES -->\nkeep me\n"
            state.write_text(malformed)
            result = run(str(sync), cwd=repository, check=False)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(state.read_text(), malformed)
            reversed_markers = (
                "# STATE.md\n<!-- END MANUAL NOTES -->\nkeep me\n"
                "<!-- BEGIN MANUAL NOTES -->\n"
            )
            state.write_text(reversed_markers)
            result = run(str(sync), cwd=repository, check=False)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(state.read_text(), reversed_markers)

    def test_historical_and_russian_guides_cannot_override_current_contract(self):
        for path in (ROOT / "onboarding.md", ROOT / "APPENDIX-SKILLS-GUIDE.md"):
            self.assertIn("Исторический материал", "\n".join(path.read_text().splitlines()[:10]))
        russian = (ROOT / "universal-project-agent-template/ru/README.ru.md").read_text()
        self.assertIn("Основной канон шаблона ведётся на английском", russian)
        self.assertNotIn("человек общается только с Lead", russian)

    def test_template_mirrors_and_archive_match(self):
        run("python3", "scripts/sync-template-mirrors.py", "--check")
        run("python3", "scripts/package-template.py", "--check")


if __name__ == "__main__":
    unittest.main(verbosity=2)
