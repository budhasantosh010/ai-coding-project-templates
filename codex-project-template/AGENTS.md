# AGENTS.md — project operating rules

Codex reads this file automatically before work begins.

## 1. Project scope

- Project name: `<PROJECT_NAME>`
- Project root: `<PROJECT_ROOT>`
- Treat this project root as the single source of truth.
- Keep project changes inside this root unless the user explicitly authorizes another location.
- Preserve unrelated user work.

## 2. Required context reload

Before acting, read:

1. `AGENTS.md`
2. `DOCS/INDEX.md`
3. `DOCS/CURRENT_STATE.md`
4. `DOCS/HANDOVER_RUNBOOK.md`
5. `DOCS/BUILD_TRACKER.md`
6. Latest relevant `DOCS/PROJECT_LOG.md` entries
7. The active plan under `DOCS/plans/`

Read `DOCS/REQUIREMENTS.md`, `DECISIONS.md`, `FAILURE_REGISTRY.md`, and relevant change
records before implementation. Search the raw transcript when exact intent is uncertain.

Reload this context:

- before every new implementation task;
- after compaction, resume, or a new thread;
- after a user correction;
- after three commits;
- after an integration failure;
- before paid, destructive, external, or final-output work.

## 3. Zero Chinese Whispers

- Preserve exact user intent.
- Separate verified facts, historical claims, assumptions, and proposals.
- Never guess when project evidence can answer.
- Never silently rewrite history; append a dated correction.
- Project files and tests are authoritative. Codex memory is supplementary only.

## 4. Exact user-message transcript

The trusted project-local `UserPromptSubmit` hook writes each message word-for-word to:

`DOCS/_raw/user_messages.txt`

At the first message of a session:

1. Check that the hook is trusted.
2. Confirm the newest prompt appears exactly once.
3. If not proven, report and repair/test logging.
4. Never manually duplicate a message already written by the hook.

## 4b. Auto-injected context — treat it as ground truth

Three trusted hooks automatically push project context into your view so you cannot drift or
forget, even after compaction:

- `inject_context.ps1` (**SessionStart**, incl. source=compact) — re-injects CURRENT_STATE plus
  the DECISIONS/REQUIREMENTS/FAILURE catalog. After a compaction this is your spine; trust it.
- `inject_on_prompt.ps1` (**UserPromptSubmit**) — attaches the active rules plus a transcript
  pointer to every message.
- `inject_decisions_preedit.ps1` (**PreToolUse: apply_patch/Edit/Write**) — puts the active
  DEC/REQ rules right next to each edit. If your edit would break one, STOP and flag it.

When injected context disagrees with your memory, the injected DOCS win. If the user asks
"did you remember X?", check the injected catalog and `DOCS/_raw/user_messages.txt` — never guess.

## 5. Change workflow

Before modifying code:

1. Follow `DOCS/CHANGE_POLICY.md`.
2. Identify the Requirement ID and exact intended outcome.
3. State what must not change.
4. Define acceptance criteria, evidence level, expected files, and rollback.
5. Check related Decision IDs and Failure IDs.
6. Create or confirm a clean Git baseline.

During implementation:

- Follow `DOCS/ANTI_DRIFT_PROTOCOL.md`.
- Implement one coherent acceptance criterion at a time.
- Write a failing test or characterization check first.
- Make the smallest relevant change.
- Do not mix refactoring with behavior changes.
- Do not perform unrelated cleanup.

After implementation:

- Run focused and proportional regression checks.
- Inspect the Git diff.
- Update authoritative documentation.
- Create one coherent commit containing the Requirement ID.
- Record evidence, limitations, commit hash, and rollback.

## 6. Anti-drift stop conditions

- Evidence is required before starting the next task.
- If the same blocker occurs three consecutive times, stop blind retries and diagnose/report it.
- Fallbacks, skipped verification, degraded output, cost changes, and uncertainty must be explicit.
- If the diff contains unrelated files, stop and split the change.
- Never call work DONE merely because code exists or imports.

## 7. Evidence levels

- `E0` — described only
- `E1` — implementation exists
- `E2` — isolated test passes
- `E3` — integrated workflow passes
- `E4` — complete real output passes
- `E5` — repeated successfully in another representative scenario

## 8. Safety and speed

- Ask before destructive actions, external publication, paid resources, or expanded scope.
- Never place secrets in source, documentation, logs, examples, Git, or memory.
- Speed comes from small verified loops, parallel read-only inspection, caching, and resumability.
- Never gain speed by skipping context, tests, diff review, or documentation.

