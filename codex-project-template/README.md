# Codex Project Template

Portable, project-local continuity, anti-drift, traceability, and rollback system for Codex.
It does not modify global Codex configuration.

## Install

1. Copy this template's contents into the target project root.
2. Replace `<PROJECT_NAME>`, `<PROJECT_ROOT>`, `<OWNER>`, `<DATE>`, and other placeholders.
3. Open Codex at that project root and trust the project.
4. Review/trust project hooks with `/hooks`.
5. Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_project_setup.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_governance.ps1
```

6. If the project has no Git history, initialize it only after reviewing `.gitignore`:

```powershell
git init -b main
git add -A
git status
git commit -m "chore: establish local project baseline"
```

7. Paste `DOCS/STARTUP_MESSAGE.md` into the first new Codex thread.
8. Confirm the message appears exactly once in `DOCS/_raw/user_messages.txt`.

## What this prevents

- instructions evaporating between sessions;
- context-window compaction losing important requirements;
- an agent becoming sloppy after many unchecked steps;
- repeated blind retries;
- silent fallbacks and false DONE claims;
- architecture changes with no explanation;
- changes that cannot be safely rolled back.

## Source of truth

```text
AGENTS.md                mandatory rules
REQUIREMENTS.md          what the user needs
DECISIONS.md             why architecture choices were made
FAILURE_REGISTRY.md      recurring mistakes and regression protection
CURRENT_STATE.md         verified present truth
plans/                   ordered future work
changes/                 requirement → files → tests → commit → rollback
PROJECT_LOG.md           append-only history
_raw/user_messages.txt   exact original wording
Git                      exact file history and rollback
```

Codex memory is helpful but never the only place for required knowledge.

