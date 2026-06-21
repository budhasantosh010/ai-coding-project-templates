# Anti-drift execution protocol

No agent can honestly promise zero mistakes. This protocol's job is different: make mistakes
**small, visible, reversible, and unable to compound.** A 0.01% slip that compounds becomes a
disaster; a 0.01% slip that's caught in the next loop is nothing.

## User-intent checksum — fill this in BEFORE each task

```text
Requirement:            (REQ-XXX)
Exact intended outcome:
What must not change:
Acceptance test:
Evidence level (target):
Rollback:
```

If you can't fill these in, you don't understand the task yet — go re-read, don't start coding.

## One active scope at a time

```
Only ONE coherent acceptance criterion is "in flight" at any moment.
Split work that mixes unrelated behavior + architecture + cleanup, or that has more than one
independently-verifiable outcome. Mixed diffs are where bugs hide.
```

## The short verified loop

```
reload intent → write failing test / reproduction → smallest change → focused test →
inspect the diff → regression check → commit + document → reload for the next task
```

## Evidence before continuation

Do NOT start the next task until the current one has: explicit evidence, an inspected diff,
updated status, and either a coherent commit or a clearly-reported blocker.

## Context-reload checkpoints

Reload requirements + current state + active plan + relevant decisions:
- before each new task;
- after compaction / resume / new session;
- after a user correction;
- after three commits;
- after an integration failure;
- before paid / destructive / external / final work;
- whenever intent feels uncertain.

## Three-strike stop rule

```
Same failure 3 times in a row?  →  STOP.
Preserve the errors. Re-read the requirement + failure registry. Diagnose the ROOT cause,
or report the blocker. There is NO fourth blind attempt.
```

## No silent fallback

If you fall back to a lesser approach, skip a check, or output something degraded — say so out
loud: WHAT failed, the fallback used, the quality lost, whether it's acceptable, and the final
degraded status. Silent degradation is the worst failure mode.

## Stop-the-line conditions

Stop immediately when: work contradicts a requirement, verification got skipped, the diff
contains unrelated files, output silently degraded, cost/time changed materially, or a
previously-fixed defect returned.

## Speed without skipping gates

Go fast through parallel read-only inspection, small tests, caching, resumability, and reusing
components. NEVER buy speed by skipping context, tests, diff review, or documentation.
