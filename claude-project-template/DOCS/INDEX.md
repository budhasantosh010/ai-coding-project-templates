# Documentation index — the map of all docs

This is the table of contents for the whole system. It also says **which doc wins** when two
docs seem to disagree (the "conflict order"), so there's never any ambiguity.

## Every doc and what it's the boss of

| Document | Authority (what it's the final word on) |
|---|---|
| `CLAUDE.md` | Mandatory Claude operating rules (the short rulebook) |
| `DOCS/STARTUP_MESSAGE.md` | The exact prompt to paste at the start of a session |
| `DOCS/BOOTSTRAP_PROMPT.md` | Prompt to install this system into a brand-new project |
| `DOCS/CURRENT_STATE.md` | What is verified-true RIGHT NOW |
| `DOCS/REQUIREMENTS.md` | Stable, testable things the user needs (REQ-XXX) |
| `DOCS/DECISIONS.md` | Architecture choices and WHY (DEC-XXX) |
| `DOCS/FAILURE_REGISTRY.md` | Recurring failures + the test that stops them coming back (FAIL-XXX) |
| `DOCS/ANTI_DRIFT_PROTOCOL.md` | The safeguards that keep quality from decaying on long tasks |
| `DOCS/CHANGE_POLICY.md` | The required path from "raw request" to "committed, evidenced change" |
| `DOCS/CHANGE_RECORD_TEMPLATE.md` | The form to fill in for each meaningful change |
| `DOCS/changes/` | One filled-in record per change |
| `DOCS/GIT_RUNBOOK.md` | Local commit / branch / rollback commands |
| `DOCS/HANDOVER_RUNBOOK.md` | Zero-context operator's guide (verified instructions only) |
| `DOCS/BUILD_TRACKER.md` | Concise status board (done/doing/todo/blocked) |
| `DOCS/PROJECT_LOG.md` | Append-only chronological history (what/why/outcome) |
| `DOCS/STATECHART.md` | Optional high-level picture of the same history |
| `DOCS/plans/` | Ordered, step-by-step implementation plans |
| `DOCS/runs/` | Evidence captured from real executions |
| `DOCS/_raw/user_messages.txt` | The exact original wording of every user message |

## Conflict order — who wins when docs disagree

```
1. RAW TRANSCRIPT      (DOCS/_raw/user_messages.txt)  ── what the user ACTUALLY said
        ▲ beats everything below
2. REQUIREMENTS        (REQ-XXX)                        ── the testable intent
3. DECISIONS           (DEC-XXX)                        ── deliberate architecture
4. CURRENT CODE + TESTS                                 ── actual present behavior
5. CURRENT_STATE.md                                     ── must match verified reality
6. HISTORICAL RECORDS  (PROJECT_LOG, old changes)       ── corrected by APPENDING, never deleting
```

Read it top-down: if a requirement seems to contradict the raw transcript, the **transcript
wins** and the requirement is the thing that's wrong. History is never silently rewritten —
you fix it by adding a dated correction lower down.
