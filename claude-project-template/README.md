# Claude Project Template

A portable, project-local **continuity + anti-drift + traceability + rollback** system for
Claude Code. Drop it into any project and Claude stops forgetting, stops drifting, stops lying
about "done," and can't make a change you can't undo. It does **not** touch your global Claude
settings.

## The idea in one picture

```
WITHOUT this template            WITH this template
─────────────────────            ──────────────────
Claude forgets between           Every message + decision + change is written to DOCS/,
sessions; you re-explain;        so a fresh session reloads the FULL context and keeps going.
"done" might mean nothing.       "Done" now requires EVIDENCE (E0–E5), not just code existing.
```

```
your project/
├─ CLAUDE.md            ← the short rulebook Claude auto-loads
├─ .claude/settings.json← wires the message-logging hook
├─ hooks/               ← logger + two self-checks
└─ DOCS/                ← the brain: index, requirements, decisions, failures,
                          anti-drift rules, change records, history, transcript
```

## Install

1. Copy this template's contents into your project root.
2. Replace `<PROJECT_NAME>`, `<PROJECT_ROOT>`, `<OWNER>`, `<DATE>`, and the other `<...>` placeholders.
3. Open the project in Claude Code; trust the project + its hooks.
4. Run the self-checks:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_project_setup.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_governance.ps1
```

5. If the project has no Git history, initialize it AFTER reviewing `.gitignore`:

```powershell
git init -b main
git add -A
git status
git commit -m "chore: establish local project baseline"
```

6. Paste `DOCS/STARTUP_MESSAGE.md` (the first-session block) into the first Claude chat.
7. Confirm that message appears exactly once in `DOCS/_raw/user_messages.txt`.

## What this prevents

- instructions evaporating between sessions;
- context-window compaction losing important requirements;
- Claude getting sloppy after many unchecked steps;
- repeated blind retries (the three-strike rule stops them);
- silent fallbacks and false "DONE" claims;
- architecture changes with no recorded reason;
- changes that can't be safely rolled back.

## Source of truth

```text
CLAUDE.md                mandatory rules
REQUIREMENTS.md          what the user needs (REQ-XXX)
DECISIONS.md             why architecture choices were made (DEC-XXX)
FAILURE_REGISTRY.md      recurring mistakes + regression protection (FAIL-XXX)
CURRENT_STATE.md         verified present truth
plans/                   ordered future work
changes/                 requirement → files → tests → commit → rollback
PROJECT_LOG.md           append-only history
_raw/user_messages.txt   exact original wording
Git                      exact file history + rollback
```

Claude's own memory is helpful, but it is NEVER the only place required knowledge lives.

## License

Use it, fork it, ship it.
