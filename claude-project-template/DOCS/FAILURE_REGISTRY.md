# Failure registry

Every recurring failure gets a stable `FAIL-XXX` ID and a **regression test** — the check that
proves it can't silently come back. A bug without a regression test is not "fixed," it's "asleep."

## Failure template

```text
## FAIL-XXX — <short name>

Status: OPEN / FIXED / MONITORING
First observed:
Last reproduced:

Symptom:                (what you SEE when it happens)

Scope:                  (what's affected)

Root cause:             (the real underlying reason — not the surface symptom)

Fix:                    (what was changed)

Regression test:        (the test/command that fails if it returns)

Evidence:               (proof the fix works — evidence level)

Related decisions/runs:
```
