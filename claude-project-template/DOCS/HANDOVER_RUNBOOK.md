# Handover runbook

The zero-context operator's guide: if someone (or a fresh Claude session) lands here knowing
NOTHING, this gets them safely running. Include only instructions that are **currently verified**.

## Objective

`<PROJECT_OBJECTIVE>`

## Required environment

- Project root: `<PROJECT_ROOT>`
- Platform/runtime: `<PLATFORM>`
- Required dependencies: `<DEPENDENCIES>`

## Safe startup

1. Read the files listed in `CLAUDE.md` section 1 (the read-first list).
2. Run `hooks/verify_project_setup.ps1` → expect all required files PASS.
3. Review `DOCS/CURRENT_STATE.md` → what's actually true right now.
4. Identify the active plan in `DOCS/plans/`.
5. Run the project's non-destructive preflight (if it has one).

## Canonical commands

| Purpose | Command | Expected result |
|---|---|---|
| Verify documentation setup | `powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_project_setup.ps1` | Required files PASS |
| Governance self-audit | `powershell -NoProfile -ExecutionPolicy Bypass -File .\hooks\verify_governance.ps1` | All rule checks PASS |

## Recovery — when a run fails

1. Preserve the exact error (copy it verbatim).
2. Check `DOCS/FAILURE_REGISTRY.md` — is this a known FAIL-XXX?
3. Reproduce with the smallest non-destructive test.
4. If it's new, add a failure entry.
5. Do NOT mark the fix complete until its regression test passes.

## Prohibited assumptions (these have burned people before)

- A historical "DONE" label is NOT current proof — re-verify.
- Claude's memory is NOT authoritative project documentation — the files are.
- A successful import is NOT a successful integrated workflow — that's E1, not E3.
