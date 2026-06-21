# AI Coding Project Templates

Two drop-in templates that give an AI coding agent a **memory + governance system** for any
project — so it stops forgetting between sessions, stops drifting on long tasks, stops claiming
"done" without proof, and can't make a change you can't undo.

Same system, one folder per agent:

```
ai-coding-project-templates/
├─ claude-project-template/   ← for Claude Code   (rulebook = CLAUDE.md,  hook via .claude/settings.json)
└─ codex-project-template/    ← for OpenAI Codex  (rulebook = AGENTS.md,  hook via .codex/hooks.json)
```

Both are **identical in structure and intent** — only the agent-specific filenames differ.

## Table of contents

- [What problem do these solve?](#what-problem-do-these-solve)
- [Pick your agent](#pick-your-agent)
- [Install (per project)](#install-per-project)
- [How RECALL is forced, not hoped-for](#how-recall-is-forced-not-hoped-for) — the auto-injection hooks
- [What's inside each template](#whats-inside-each-template-the-shared-brain)
- [Optional companion: graphify](#optional-companion-graphify-for-huge-codebases)
  - [Does graphify auto-fire from these templates?](#does-graphify-auto-fire-from-these-templates)
  - [graphify: install ONCE, build PER PROJECT](#graphify-install-once-build-per-project)
  - [Does it cost money? (the honest caveat)](#does-it-cost-money-the-honest-caveat)
  - [You don't need the paid step — structure-only is enough](#you-dont-need-the-paid-step--structure-only-is-enough)
- [License](#license)

## What problem do these solve?

```
WITHOUT a template                      WITH a template
──────────────────                      ───────────────
Agent forgets everything between        Every message + decision + change is written to DOCS/,
sessions; you re-explain endlessly.     so a fresh session reloads the FULL context and continues.

"Done" can mean "the code exists"       "Done" requires EVIDENCE (E0–E5): a passing test or a
even if it was never run.                real run — not just code that imports.

Same error retried forever.             Three-strike rule: same failure 3× → stop & diagnose.

Silent fallbacks, lost reasons,         No silent fallback. Decisions logged. Failures registered
unrepeatable bugs.                       with regression tests so they can't quietly return.
```

## Pick your agent

| You use… | Open this folder | Its rulebook |
|---|---|---|
| **Claude Code** (CLI / VS Code ext / desktop) | `claude-project-template/` | `CLAUDE.md` |
| **OpenAI Codex** (CLI / VS Code ext / desktop) | `codex-project-template/` | `AGENTS.md` |

## Install (per project)

You do this once **per project** (copying the template in). The short version:

1. Copy your chosen folder's contents into your project root.
2. Replace the `<PROJECT_NAME>` / `<PROJECT_ROOT>` / `<OWNER>` / `<DATE>` placeholders.
3. Open the project in your agent and trust its hooks.
4. Run the two `hooks/verify_*.ps1` self-checks (they should all PASS).
5. Paste that folder's `DOCS/STARTUP_MESSAGE.md` first-session block into the first chat
   (also collected in [START_HERE.md](START_HERE.md)).

## How RECALL is forced, not hoped-for

The hardest problem with AI agents is that they **forget**: a long session compacts, the
codebase grows, and the model silently loses what you told it. ("You said pnpm not npm. Next
session it runs npm again.")

These templates don't just *save* your context to disk — they **push it back into the model's
view automatically**, via hooks, at the three exact moments forgetting happens:

```
WHEN forgetting happens          WHICH hook fires             WHAT it re-injects
─────────────────────            ────────────────             ──────────────────
session compacts / resumes  →    inject_context           →   CURRENT_STATE + DEC/REQ/FAIL catalog
you send any message        →    inject_on_prompt         →   the active rules + "read the transcript"
just before an edit (step 15)→   inject_decisions_preedit →   the active DEC/REQ rules, AT the edit
```

```
A markdown rule the agent must CHOOSE to read   = a sign on the wall (it can walk past).
A hook that injects the rule automatically       = the rule is already on screen (can't miss it).
```

So a preference like "pnpm not npm" stops depending on the model *remembering* — it's placed
in front of the agent every session, every message, and every edit. The information being
**present** is guaranteed (the hook can't be skipped). All injectors fail safe: on any error
they emit nothing and never block your session.

> This is the difference between *"please remember"* and *"the answer is already on the screen."*

## What's inside each template (the shared brain)

```
<root>/
├─ CLAUDE.md / AGENTS.md   the short rulebook the agent auto-loads
├─ .claude/ or .codex/     wires the logging + 3 context-injection hooks
├─ hooks/                  logger + 3 auto-injectors (recall) + 2 self-verifying checks
│   ├─ log_user_message.ps1          saves every message word-for-word
│   ├─ inject_context.ps1            re-injects the spine on session start / after compaction
│   ├─ inject_on_prompt.ps1          injects active rules alongside every message
│   ├─ inject_decisions_preedit.ps1  injects active rules right before each edit
│   ├─ verify_project_setup.ps1      checks every required file exists
│   └─ verify_governance.ps1         checks the rules haven't rotted away
└─ DOCS/
   ├─ INDEX.md             map of all docs + conflict order (who wins)
   ├─ CURRENT_STATE.md     what's verified-true right now (+ E0–E5 legend)
   ├─ REQUIREMENTS.md      testable user needs (REQ-XXX)
   ├─ DECISIONS.md         architecture choices + why (DEC-XXX)
   ├─ FAILURE_REGISTRY.md  recurring bugs + regression tests (FAIL-XXX)
   ├─ ANTI_DRIFT_PROTOCOL.md  short-loop, three-strike, no-silent-fallback
   ├─ CHANGE_POLICY.md     raw → REQ → evidence → one commit → record
   ├─ CHANGE_RECORD_TEMPLATE.md
   ├─ GIT_RUNBOOK.md       safe commit / branch / rollback
   ├─ HANDOVER_RUNBOOK.md  zero-context operator guide
   ├─ STARTUP_MESSAGE.md   prompts to paste at session start
   ├─ BOOTSTRAP_PROMPT.md  "install this system into a fresh project" prompt
   ├─ PROJECT_LOG.md       append-only history
   ├─ BUILD_TRACKER.md     status board
   ├─ STATECHART.md        optional visual
   ├─ plans/ changes/ runs/
   └─ _raw/user_messages.txt   exact word-for-word transcript
```

## Optional companion: graphify (for huge codebases)

These templates give the agent **episodic + procedural memory** — what you said, what was
decided, what failed, how you work. They do **not** map *where the code is*. On a large
codebase, that second kind of memory matters too, and a great open tool already does it:
[graphify](https://github.com/safishamsi/graphify) builds a queryable **knowledge graph** of
your code so the agent looks things up instead of grepping 200 files.

```
THESE TEMPLATES                         GRAPHIFY
───────────────                         ────────
"what did we DECIDE / say / try?"       "WHERE is the auth code, what calls it?"
episodic + procedural memory (a DIARY)  spatial/code memory (a MAP)
────────────────────────────────────────────────────────────────────
            Different memories. Best used TOGETHER.
```

They don't overlap or conflict — run both.

### Does graphify auto-fire from these templates?

**No. They are completely separate systems.** Nothing in these templates installs, calls, or
fires graphify. Installing a template does **not** install graphify.

```
TEMPLATE alone           →  graphify does NOTHING (it isn't there).
+ graphify install       →  the AGENT auto-uses the graph DURING a session
                            (graphify's own hook nudges it to query the map instead of grepping).
+ graphify hook install  →  the MAP auto-rebuilds on every `git commit`.
```

So graphify only "auto-fires" **per project, after YOU run its own two commands in that
project** — never automatically from our templates. You stay in control.

### graphify: install ONCE, build PER PROJECT

People blur three separate events together. Here's the truth, so you know exactly what to do
for every project:

```
① INSTALL THE TOOL        → ONCE per laptop, forever.    uv tool install graphifyy
   (puts the `graphify` command on your machine)

② WIRE IT INTO A PROJECT  → ONCE per project.            graphify install            (Claude)
   (writes the skill/hook so the agent uses             graphify install --platform codex
    the graph in THAT repo)

③ BUILD THE FIRST MAP     → ONCE per project.            graphify .
   (reads the code, writes graphify-out/graph.json)

④ AUTO-REFRESH THE MAP    → ONCE per project (set&forget). graphify hook install
   (installs a POST-COMMIT git hook → every `git commit`
    rebuilds the map so it never goes stale)
```

So your instinct "install once then it runs itself" is **half right**:

```
"install once"  ✅  → step ① the tool: yes, once per laptop, forever.
"runs itself"   🟡  → the MAP does NOT rebuild on its own UNTIL you do step ④
                      (the post-commit hook). Before that, code changes leave the map stale.
```

Per machine + per project, the full picture:

```
ONE TIME on the laptop:    uv tool install graphifyy
PER PROJECT (once each):   graphify install        # agent uses the graph
                           graphify .              # build the first map
                           graphify hook install   # auto-rebuild on every commit (set & forget)
```

New project? Repeat the three per-project lines (~30 seconds). Commit `graphify-out/` so
teammates start already-mapped. Query it any time:

```bash
graphify query "what connects auth to the database?"
```

How the two systems fit together on a real task:

```
You ask: "add rate-limiting to the login route"
   │
   ├─ THIS TEMPLATE supplies the rules     → DEC-004 pnpm only · REQ-002 evidence E3
   │   (auto-injected, can't be forgotten)
   │
   └─ GRAPHIFY supplies the map            → "login route → AuthService → RateLimiter → Redis"
       (so the agent edits the RIGHT files, no grep marathon)
```

### Does it cost money? (the honest caveat)

Building the map does **two different jobs**, and only one costs anything:

```
JOB 1: read the CODE structure       → tree-sitter, runs LOCALLY on your machine.
       (functions, files, call graph)   FREE. No internet, no API, no cost.

JOB 2: understand MEANING + docs/PDFs → sent to an LLM (an API "brain") to reason about.
       (concepts, relationships,         COSTS TOKENS / $, because an LLM has to read it.
        summarizing a PDF)
```

Plain version: **mapping where code IS = free; understanding what it MEANS = costs tokens**
(an LLM has to think about it).

That's exactly why the refresh is **commit-triggered, not constant** — each rebuild spends a
little on that LLM, so graphify waits for *your* commit instead of burning money in the
background 24/7. **You control when the cost happens.**

```
💡 Want it fully FREE? graphify can use a LOCAL model (e.g. `--backend ollama`) for Job 2.
   Then nothing leaves your machine — zero API cost, just slower.
```

> Note: graphify is a separate project (not affiliated with this repo). The PyPI package is
> `graphifyy` (double-y). Add `graphify-out/cost.json` to your `.gitignore`.

### You don't need the paid step — structure-only is enough

**Job 2 (the LLM meaning layer) is optional, not required.** For "just map my codebase so the
agent finds code fast," the free structural map (Job 1) already gives you everything that
matters:

```
From the FREE structural map alone, the agent can already answer:
  ✅ where is UserService defined?          ✅ what calls login()?
  ✅ what does auth.ts import?               ✅ if I change this, what breaks?
```

And here's the key insight: **your coding agent is already a smart meaning-understander.** It
reads the structural map and infers the meaning itself, on the fly — so paying a *second* LLM
to pre-chew "what this means" is largely redundant for navigation.

```
       graphify Job 2                      your coding agent
       ──────────────                      ─────────────────
   "pre-infer meaning, bake it in"   vs    "just read the structure, I'll
            │ costs tokens                   understand it myself" │ free, already happening
```

What you give up by skipping Job 2 (all nice-to-haves, none essential for navigation):

```
✗ understanding NON-code files (PDFs, design docs, images)
✗ INFERRED conceptual links not written literally in the code
✗ pretty human-named clusters ("Auth subsystem")
✗ extracted "why" notes from comments as separate nodes
```

```
Skip Job 2 (structure only) is the right default when:
   pure code navigation · small/medium repo · you just want "find the right file fast"

Job 2 earns its cost only when:
   you have lots of DOCS/PDFs to tie to code · a huge repo with non-obvious conceptual links ·
   onboarding people who need the "why"
```

Bottom line: **a structural map + a capable model = enough.** Treat the LLM layer as optional
polish, and if you ever want it, run it locally for free with `--backend ollama`.

## License

MIT — use it, fork it, ship it.
