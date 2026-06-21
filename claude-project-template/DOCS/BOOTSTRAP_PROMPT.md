# Bootstrap prompt — for a project that does NOT have this system yet

If you're starting fresh and want Claude to build this whole system for you (instead of copying
the template by hand), paste this into the project's first Claude Code chat.

```text
Before product implementation, install a project-local continuity, anti-drift, traceability, and
rollback system. Do not change global Claude settings.

Use this project root:
<PROJECT_ROOT>

Create:
- CLAUDE.md with mandatory startup context-reload and anti-drift rules;
- a project-local .claude/settings.json wiring a UserPromptSubmit hook;
- hooks/log_user_message.ps1 that appends each message word-for-word to
  DOCS/_raw/user_messages.txt;
- hooks/verify_project_setup.ps1 and hooks/verify_governance.ps1 self-checks;
- DOCS/INDEX.md, CURRENT_STATE.md, REQUIREMENTS.md, DECISIONS.md,
  FAILURE_REGISTRY.md, HANDOVER_RUNBOOK.md, BUILD_TRACKER.md, PROJECT_LOG.md,
  ANTI_DRIFT_PROTOCOL.md, CHANGE_POLICY.md, CHANGE_RECORD_TEMPLATE.md,
  GIT_RUNBOOK.md, STATECHART.md, plans/, changes/, runs/, and the raw transcript;
- a reviewed .gitignore and a local Git baseline if no valid repository exists.

Required behavior:
- exact user messages stay word-for-word and append-only;
- important instructions move into project files, not only chat or model memory;
- each meaningful change links raw intent → Requirement ID → Decision/Failure ID →
  plan → tests/evidence → ONE coherent Git commit → change record → rollback;
- only one acceptance criterion is implemented at a time;
- context reload happens before every task and after compaction/resume/corrections;
- evidence is required before continuation;
- three repeated identical failures stop blind retries;
- fallbacks and skipped verification are stated explicitly;
- no feature is DONE merely because code exists;
- no paid, destructive, external, or scope-expanding action without approval.

Verify the system with the automated checks and a synthetic prompt logged exactly once. Do not
begin product implementation until you report the files created, tests run, Git state,
limitations, and the exact startup prompt for future sessions.
```
