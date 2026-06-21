# Requirements registry

Raw messages preserve exact wording. This file turns durable intent into stable, testable IDs.

## Requirement template

```text
## REQ-XXX — Title
Status: ACTIVE / SATISFIED / SUPERSEDED
Source:
Intent:
Acceptance criteria:
Required evidence level:
Related decisions:
Related failures:
Related changes/commits:
```

## REQ-001 — Preserve exact user intent

Status: ACTIVE

Acceptance criteria:

- Exact messages are retained locally.
- Significant work references a Requirement ID.
- Disputed interpretations return to the raw wording.

Required evidence level: E3

## REQ-002 — Prevent long-session quality decay

Status: ACTIVE

Acceptance criteria:

- Work uses one-criterion verified loops.
- Context reload checkpoints are followed.
- Evidence is required before continuation.
- Three repeated failures stop blind retries.
- Fallbacks and skipped checks are explicit.

Required evidence level: E3

## REQ-003 — Safe reversible changes

Status: ACTIVE

Acceptance criteria:

- Git has a reviewed baseline.
- One coherent change per commit.
- Every meaningful change records tests and rollback.
- Architecture extraction does not silently alter behavior.

Required evidence level: E3

