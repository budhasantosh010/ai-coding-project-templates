# AI Coding Project Templates

Two drop-in templates that give an AI coding agent a **memory + governance system** for any
project — so it stops forgetting between sessions, stops drifting on long tasks, stops claiming
"done" without proof, and can't make a change you can't undo.

Same system, one folder per agent:

```
ai-coding-project-templates/
├─ claude-project-template/   ← for Claude Code   (rulebook = CLAUDE.md,  hook via .claude/settings.json)
└─ codex-project-template/    ← for OpenAI Codex  (rulebook = AGENTS.md,  hook via .codex/hooks.json)
```

Both are **identical in structure and intent** — only the agent-specific filenames differ.

## What problem do these solve?

```
WITHOUT a template                      WITH a template
──────────────────                      ───────────────
Agent forgets everything between        Every message + decision + change is written to DOCS/,
sessions; you re-explain endlessly.     so a fresh session reloads the FULL context and continues.

"Done" can mean "the code exists"       "Done" requires EVIDENCE (E0–E5): a passing test or a
even if it was never run.                real run — not just code that imports.

Same error retried forever.             Three-strike rule: same failure 3× → stop & diagnose.

Silent fallbacks, lost reasons,         No silent fallback. Decisions logged. Failures registered
unrepeatable bugs.                       with regression tests so they can't quietly return.
```

## Pick your agent

| You use… | Open this folder | Its rulebook |
|---|---|---|
| **Claude Code** (CLI / VS Code ext / desktop) | `claude-project-template/` | `CLAUDE.md` |
| **OpenAI Codex** (CLI / VS Code ext / desktop) | `codex-project-template/` | `AGENTS.md` |

Each folder has its own README with full install steps. The short version:

1. Copy the folder's contents into your project root.
2. Replace the `<PROJECT_NAME>` / `<PROJECT_ROOT>` / `<OWNER>` / `<DATE>` placeholders.
3. Open the project in your agent and trust its hooks.
4. Run the two `hooks/verify_*.ps1` self-checks (they should all PASS).
5. Paste that folder's `DOCS/STARTUP_MESSAGE.md` first-session block into the first chat.

## What's inside each template (the shared brain)

```
<root>/
├─ CLAUDE.md / AGENTS.md   the short rulebook the agent auto-loads
├─ .claude/ or .codex/     wires the "log every message" hook
├─ hooks/                  logger + two self-verifying checks
└─ DOCS/
   ├─ INDEX.md             map of all docs + conflict order (who wins)
   ├─ CURRENT_STATE.md     what's verified-true right now (+ E0–E5 legend)
   ├─ REQUIREMENTS.md      testable user needs (REQ-XXX)
   ├─ DECISIONS.md         architecture choices + why (DEC-XXX)
   ├─ FAILURE_REGISTRY.md  recurring bugs + regression tests (FAIL-XXX)
   ├─ ANTI_DRIFT_PROTOCOL.md  short-loop, three-strike, no-silent-fallback
   ├─ CHANGE_POLICY.md     raw → REQ → evidence → one commit → record
   ├─ CHANGE_RECORD_TEMPLATE.md
   ├─ GIT_RUNBOOK.md       safe commit / branch / rollback
   ├─ HANDOVER_RUNBOOK.md  zero-context operator guide
   ├─ STARTUP_MESSAGE.md   prompts to paste at session start
   ├─ BOOTSTRAP_PROMPT.md  "install this system into a fresh project" prompt
   ├─ PROJECT_LOG.md       append-only history
   ├─ BUILD_TRACKER.md     status board
   ├─ STATECHART.md        optional visual
   ├─ plans/ changes/ runs/
   └─ _raw/user_messages.txt   exact word-for-word transcript
```

## License

MIT — use it, fork it, ship it.
