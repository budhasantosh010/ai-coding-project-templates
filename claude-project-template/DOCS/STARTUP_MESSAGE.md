# Startup messages

Copy-paste these into Claude Code at the right moment. They make Claude load the whole
continuity + anti-drift system before doing anything.

## First session after copying this template

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
- Confirm the UserPromptSubmit hook is active and THIS message appears exactly once in
  DOCS/_raw/user_messages.txt.
- Separate verified current facts from historical claims.
- Report contradictions, remaining placeholders, Git state, genuine evidence level, and the next task.

Do not implement product changes yet. First prove that continuity, anti-drift, documentation,
and rollback safeguards are active.
```

## Every later new session

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

## Continue implementation after context is confirmed

```text
Proceed with the next unblocked acceptance criterion in the active plan. Use a test-first or
characterization test, make the smallest scoped change, run focused + regression checks,
inspect the diff, create one Requirement-ID commit, and update the change record and the
authoritative documentation. Report outcome, evidence, commit, limitation, and next task.
```
