# Change policy

The required path from "the user said something" to "a safe, committed, evidenced change."
Every meaningful change follows this chain — no skipping links.

## Traceability chain

```text
Raw message → Requirement ID → Decision/Failure ID → plan task →
test/evidence → ONE coherent change → Git commit → change record
```

Read it as: nothing gets built that you can't trace back to something the user actually said.

## Before changing code

1. Identify the **Requirement ID** and its raw source.
2. State acceptance criteria and **non-goals** (what must NOT change).
3. Identify any related **Decision ID** and **Failure ID**.
4. List the expected files.
5. Define the evidence level and the rollback.
6. Confirm a clean Git state, or create a branch.

## During the change

- Make ONE coherent change.
- Add a failing test or a characterization check FIRST.
- Preserve behavior during refactoring.
- Avoid unrelated cleanup (that's a separate change).

## After changing code

1. Run focused + regression checks.
2. Inspect the diff.
3. Confirm the changed files match the requirement (no strays).
4. Update the authoritative docs (CURRENT_STATE, BUILD_TRACKER, PROJECT_LOG, change record).
5. Commit with the Requirement ID.
6. Record the commit hash, limitations, and rollback.

## Commit format

```
type(REQ-XXX): concise outcome
```
e.g. `fix(REQ-002): stop blind retry after three identical failures`
