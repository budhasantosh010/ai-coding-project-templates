# CLAUDE.md — project rules   (keep this file SMALL; deep detail lives in DOCS\)

These rules load automatically at the start of every session in this project.
Claude: follow them for the ENTIRE session. This file is the **map**; the DOCS it
points to are the **territory**.

```
        YOU (the user)                 CLAUDE (me)
              │                            │
              │  message ──► hook ──► DOCS/_raw/user_messages.txt  (word-for-word)
              │                            │
              ▼                            ▼
   CLAUDE.md (this file) ──points at──► DOCS/  (the real detail)
        the short rulebook              INDEX · REQUIREMENTS · DECISIONS · FAILURES · ...
```

## 0) Golden rules — how to work
- **100% precision, ZERO information loss** (the "Chinese Whispers" rule): a stranger with no
  prior context reading our DOCS must understand it EXACTLY as we do.
- **Explain like I'm a curious 12-year-old**; prefer ASCII trees/diagrams.
- **Append-only everywhere**: never delete old notes. If something changed, ADD a new entry
  that says what changed and why.
- **The repo is the truth, not your memory.** Project files + tests win over anything you
  "remember." When they disagree, the files are right.

## 1) AT THE START OF EVERY SESSION — READ BEFORE DOING ANYTHING
Load context first, in this order, BEFORE answering or acting:
  1. `CLAUDE.md` — these rules (you're reading it)
  2. `DOCS/INDEX.md` — the map of every doc + which one wins in a conflict
  3. `DOCS/CURRENT_STATE.md` — what is verified-true RIGHT NOW
  4. `DOCS/HANDOVER_RUNBOOK.md` — the zero-context operator's guide
  5. `DOCS/BUILD_TRACKER.md` — status board: done / doing / todo / blocked
  6. Latest relevant `DOCS/PROJECT_LOG.md` entries — what happened and WHY
  7. The active plan under `DOCS/plans/`
Also read `DOCS/REQUIREMENTS.md`, `DOCS/DECISIONS.md`, and `DOCS/FAILURE_REGISTRY.md` before
you implement anything. If unsure what was said, search `DOCS/_raw/user_messages.txt`.

**Reload this context** before every new task, AND after: compaction/resume/new session, a
user correction, three commits, an integration failure, or before any paid/destructive/external
/final-output work.

## 2) RECORD EVERY USER MESSAGE (the transcript)
- A hook (`.claude/settings.json` → `hooks/log_user_message.ps1`) appends each message
  word-for-word to `DOCS/_raw/user_messages.txt`. At the first message of a session, confirm
  it landed there **exactly once**. If the hook isn't proven active, append it yourself and
  report it. Never silently duplicate a message the hook already wrote.

## 2b) AUTO-INJECTED CONTEXT — treat it as ground truth
Three hooks automatically push project context into your view so you cannot drift or forget:
- `inject_context.ps1` (**SessionStart**, incl. after compaction) — re-injects CURRENT_STATE +
  the DECISIONS/REQUIREMENTS/FAILURE catalog. After a compaction this is your spine; trust it.
- `inject_on_prompt.ps1` (**UserPromptSubmit**) — attaches the active rules + a transcript
  pointer to every message.
- `inject_decisions_preedit.ps1` (**PreToolUse: Edit/Write**) — puts the active DEC/REQ rules
  right next to each edit. If your edit would break one, STOP and flag it.
When injected context disagrees with your memory, **the injected DOCS win.** If a user asks
"did you remember X?", check the injected catalog and `DOCS/_raw/user_messages.txt` — do not guess.

## 2c) DECISION TREE — record decisions, and roll back on command
Every real decision is logged to `DOCS/_raw/decisions.jsonl` and drawn as a tree the user can
see (`DOCS/decision_tree.svg` + `.mmd`). This is how the user points at work precisely.

- **When you make a real decision** (picked an option, set a direction, chose an approach),
  record it — supply the user **message number** it came from (see `msg=N` in
  `user_messages.txt`):
  ```
  powershell -NoProfile -ExecutionPolicy Bypass -File hooks\record_decision.ps1 `
    -Id DEC-00X -Msg <n> -Title "<short>" -Options "a,b,c" -Chosen "b" -Parent DEC-00Y -Status chosen
  ```
  Use `-Parent ROOT` for the top-level goal. The tree redraws automatically (zero tokens).
- **When the user names a `DEC-XXX` or a message number and says it was wrong / "roll back"**,
  do NOT guess what to undo. Run the deterministic tool — preview first, then apply on confirm:
  ```
  hooks\rollback_to_decision.ps1 -Id DEC-XXX          # preview (changes nothing)
  hooks\rollback_to_decision.ps1 -Id DEC-XXX -Apply   # git-revert to that checkpoint + redraw tree
  ```
  The decision's stored commit hash is the single source of truth — there is nothing to
  interpret. Report the preview before applying.

## 3) ZERO CHINESE WHISPERS
- Preserve exact user intent. Keep verified facts, historical claims, assumptions, and
  proposals clearly separate — never blur them.
- Never guess when a project file can answer. Never silently rewrite history; append a dated
  correction instead.

## 4) CHANGE WORKFLOW (before you touch code)
Follow `DOCS/CHANGE_POLICY.md`. In short:
  1. Identify the **Requirement ID** (REQ-XXX) and the exact intended outcome.
  2. State what must **not** change.
  3. Define acceptance criteria, the **evidence level** you'll reach, expected files, rollback.
  4. Check related Decision IDs (DEC-XXX) and Failure IDs (FAIL-XXX).
  5. Confirm a clean Git baseline.
Then implement ONE acceptance criterion at a time (test-first), smallest change, inspect the
diff, run focused + regression checks, make ONE commit naming the REQ-XXX, update the docs.

## 5) ANTI-DRIFT STOP CONDITIONS (read `DOCS/ANTI_DRIFT_PROTOCOL.md`)
- **Evidence before continuation** — don't start the next task until this one has proof.
- **Three-strike rule** — same failure 3× in a row → STOP, diagnose root cause, don't blind-retry.
- **No silent fallback** — if you fall back, degrade quality, or skip a check, SAY SO loudly.
- **Stop the line** — if the diff has unrelated files, or work contradicts a requirement, stop & split.
- **Code existing ≠ DONE.** Imports working ≠ DONE. Only evidence makes something DONE.

## 6) EVIDENCE LEVELS — what "done" actually means
```
E0 described only      E1 code exists       E2 isolated test passes
E3 integrated workflow passes               E4 complete real output passes
E5 repeated in another representative scenario
```
Never label work DONE above the evidence you actually have.

## 7) STATUS LEGEND — the "GitHub-branch" view
`[DONE]` done & verified · `[DOING]` in progress · `[TODO]` not started · `[BLOCKED]` stuck / needs you
(emoji: 🟢 DONE · 🔵 DOING · ⚪ TODO · ❌ BLOCKED)

## 8) SAFETY & SPEED
- Ask before destructive actions, external publication, paid resources, or scope expansion.
- **Never** put secrets in source, docs, logs, examples, Git, or memory.
- Speed comes from small verified loops, parallel read-only inspection, caching, resumability —
  NEVER from skipping context, tests, diff review, or documentation.
