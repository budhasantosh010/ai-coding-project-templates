# Current verified state

Last verified: `<DATE>`

This file holds **current facts only**. Every important claim must point to current code, a
command, a test, or a run report. If it isn't verified, it goes in "Known blocked or unverified"
— never pretend something works.

## Project

- Name: `<PROJECT_NAME>`
- Root: `<PROJECT_ROOT>`
- Owner: `<OWNER>`
- Primary objective: `<OBJECTIVE>`

## Verified working

| Capability | Evidence (file/command/test) | Evidence level | Verified date |
|---|---|---|---|
| Project template installed | `hooks/verify_project_setup.ps1` | E2 | `<DATE>` |

## In progress

| Item | Current state | Next verification |
|---|---|---|
| `<ITEM>` | `<STATE>` | `<TEST OR OUTPUT>` |

## Known blocked or unverified

| Item | Why | Required next action |
|---|---|---|
| `<ITEM>` | `<REASON>` | `<ACTION>` |

## Current entry points

| Purpose | Command/file |
|---|---|
| Setup verification | `powershell -NoProfile -ExecutionPolicy Bypass -File hooks\verify_project_setup.ps1` |
| Governance self-audit | `powershell -NoProfile -ExecutionPolicy Bypass -File hooks\verify_governance.ps1` |

## Evidence-level legend

```
E0 described only   ·   E1 code exists   ·   E2 isolated test passes
E3 integrated workflow passes   ·   E4 complete real output passes   ·   E5 repeated scenario
```
