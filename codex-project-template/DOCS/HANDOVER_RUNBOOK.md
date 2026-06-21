# Handover runbook

This is the zero-context operator guide. Include only instructions that are currently verified.

## Objective

`<PROJECT_OBJECTIVE>`

## Required environment

- Project root: `<PROJECT_ROOT>`
- Platform/runtime: `<PLATFORM>`
- Required dependencies: `<DEPENDENCIES>`

## Safe startup

1. Read the files required by `AGENTS.md`.
2. Run `hooks/verify_project_setup.ps1`.
3. Review `DOCS/CURRENT_STATE.md`.
4. Identify the active plan.
5. Run the project's non-destructive preflight.

## Canonical commands

| Purpose | Command | Expected result |
|---|---|---|
| Verify documentation setup | `powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_project_setup.ps1` | Required files PASS |

## Recovery

When a run fails:

1. Preserve the exact error.
2. Check `DOCS/FAILURE_REGISTRY.md`.
3. Reproduce with the smallest non-destructive test.
4. Add a failure entry if it is new.
5. Do not mark the fix complete until its regression test passes.

## Prohibited assumptions

- Historical “DONE” labels are not current proof.
- Codex memory is not authoritative project documentation.
- A successful import is not a successful integrated workflow.

