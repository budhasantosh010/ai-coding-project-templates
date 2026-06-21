# Requirements registry

The raw transcript keeps the user's EXACT words. This file turns durable intent into stable,
**testable** IDs you can point a commit at. Each requirement gets a permanent `REQ-XXX` number.

## Requirement template

```text
## REQ-XXX — Title
Status: ACTIVE / SATISFIED / SUPERSEDED
Source:                 (which raw message / decision this came from)
Intent:                 (what the user actually wants, in plain words)
Acceptance criteria:    (the checks that prove it's met)
Required evidence level: (E0–E5)
Related decisions:      (DEC-XXX)
Related failures:       (FAIL-XXX)
Related changes/commits:
```

## REQ-001 — Preserve exact user intent

Status: ACTIVE

Acceptance criteria:

- Exact messages are retained locally (the raw transcript).
- Significant work references a Requirement ID.
- Disputed interpretations return to the raw wording.

Required evidence level: E3

## REQ-002 — Prevent long-session quality decay

Status: ACTIVE

Acceptance criteria:

- Work uses one-criterion verified loops.
- Context-reload checkpoints are followed.
- Evidence is required before continuation.
- Three repeated failures stop blind retries.
- Fallbacks and skipped checks are stated explicitly.

Required evidence level: E3

## REQ-003 — Safe, reversible changes

Status: ACTIVE

Acceptance criteria:

- Git has a reviewed baseline.
- One coherent change per commit.
- Every meaningful change records its tests and rollback.
- Refactoring does not silently alter behavior.

Required evidence level: E3
