# START HERE

This repo has **two templates** that give an AI coding agent a memory + governance system so it
stops forgetting, drifting, and faking "done." Pick the folder for your agent, copy it into your
project, and paste the startup prompt.

```
Use Claude Code?   →  claude-project-template/
Use OpenAI Codex?  →  codex-project-template/
```

## 60-second setup

```
1. Copy your chosen folder's CONTENTS into your project root.
2. Replace the placeholders:  <PROJECT_NAME> <PROJECT_ROOT> <OWNER> <DATE>
3. Open the project in your agent; trust it + its hooks.
4. Run the two self-checks (Windows PowerShell):
       powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_project_setup.ps1
       powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_governance.ps1
   → both should print PASS lines and exit 0.
5. Paste the FIRST-SESSION prompt below into the first chat.
```

---

## The prompts to paste (Claude Code)

> For Codex, use the same prompts but they're already in `codex-project-template/DOCS/STARTUP_MESSAGE.md`.
> Replace `<PROJECT_ROOT>` with your real path.

### 🟢 FIRST session (right after installing the template)

```text
Before changing anything, load the project continuity and anti-drift system.

Project root:
<PROJECT_ROOT>

Read in order:
1. CLAUDE.md
2. DOCS/INDEX.md
3. DOCS/CURRENT_STATE.md
4. DOCS/REQUIREMENTS.md
5. DOCS/HANDOVER_RUNBOOK.md
6. DOCS/BUILD_TRACKER.md
7. Latest relevant DOCS/PROJECT_LOG.md entries
8. Active DOCS/plans/ plan
9. Relevant DECISIONS.md, FAILURE_REGISTRY.md, and change records

Then:
- Confirm the actual root and active instruction files.
- Run hooks/verify_project_setup.ps1 and hooks/verify_governance.ps1.
- Confirm the message-logging hook is active and THIS message appears exactly once in
  DOCS/_raw/user_messages.txt.
- Separate verified current facts from historical claims.
- Report contradictions, remaining placeholders, Git state, genuine evidence level, and the next task.

Do not implement product changes yet. First prove that continuity, anti-drift, documentation,
and rollback safeguards are active.
```

### 🔵 EVERY later new session

```text
Reload the authoritative project context required by CLAUDE.md and DOCS/INDEX.md. Follow
DOCS/ANTI_DRIFT_PROTOCOL.md and DOCS/CHANGE_POLICY.md.

Before editing:
- confirm the active Requirement ID and exact intended outcome;
- state what must not change;
- define acceptance evidence and rollback;
- confirm Git status and active branch;
- confirm transcript logging is active.

Work on ONE coherent acceptance criterion only. Do not continue without evidence. Stop after
three identical failures. Never silently fall back or call skipped verification a success.

First report current verified state, active task, risks, and the smallest next action.
```

### ⚪ CONTINUE (once context is confirmed, to start building)

```text
Proceed with the next unblocked acceptance criterion in the active plan. Use a test-first or
characterization test, make the smallest scoped change, run focused + regression checks,
inspect the diff, create one Requirement-ID commit, and update the change record and the
authoritative documentation. Report outcome, evidence, commit, limitation, and next task.
```

---

## What each prompt is FOR (plain version)

```
🟢 FIRST    = "load the whole brain + prove the safety nets work, before touching code"
🔵 LATER    = "reload the brain, lock the target + rollback, work one thing, stop if stuck"
⚪ CONTINUE = "build the next piece the safe way: test → small change → verify → commit → document"
```

Full details live in each template's `DOCS/`. Start with `DOCS/INDEX.md` — it's the map.
