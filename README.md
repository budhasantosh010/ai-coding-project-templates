# AI Coding Project Templates

A coding agent forgets. Halfway through a build the context compacts, and suddenly it's
re-asking things you settled an hour ago or quietly ignoring a rule you set on day one. These
are two drop-in templates — one for Claude Code, one for Codex — that fix that by keeping the
project's memory in files and feeding it back to the agent automatically.

```
ai-coding-project-templates/
├─ claude-project-template/   for Claude Code   (rulebook = CLAUDE.md,  hook via .claude/settings.json)
└─ codex-project-template/    for OpenAI Codex  (rulebook = AGENTS.md,  hook via .codex/hooks.json)
```

Both folders are the same system. The only differences are the rulebook filename and how each
agent registers hooks.

## Table of contents

- [What problem do these solve?](#what-problem-do-these-solve)
- [Pick your agent](#pick-your-agent)
- [Install (per project)](#install-per-project)
- [How recall is forced, not hoped-for](#how-recall-is-forced-not-hoped-for)
- [The decision tree (see it, and roll back to it)](#the-decision-tree)
- [What's inside each template](#whats-inside-each-template)
- [Optional companion: graphify](#optional-companion-graphify)
  - [Does graphify auto-fire from these templates?](#does-graphify-auto-fire-from-these-templates)
  - [Install once, build per project](#install-once-build-per-project)
  - [Does it cost money?](#does-it-cost-money)
  - [You probably don't need the paid step](#you-probably-dont-need-the-paid-step)
- [License](#license)

## What problem do these solve?

Four things that go wrong on any long-running agent session, and what the template does about
each:

```
Without                                 With
───────                                 ────
Forgets between sessions; you           Every message, decision and change lands in DOCS/,
re-explain the project constantly.      so a fresh session reloads the full context.

"Done" means "the code exists,"         "Done" means a passing test or a real run (E0–E5),
even if it never ran.                   not just code that imports.

Same error retried forever.             Three strikes on the same failure → stop and diagnose.

Silent fallbacks; lost reasoning.       Fallbacks must be stated. Decisions and failures are
                                        logged with the test that stops them returning.
```

## Pick your agent

| You use | Open this folder | Rulebook |
|---|---|---|
| Claude Code (CLI / VS Code / desktop) | `claude-project-template/` | `CLAUDE.md` |
| OpenAI Codex (CLI / VS Code / desktop) | `codex-project-template/` | `AGENTS.md` |

## Install (per project)

Do this once per project, when you copy the template in:

1. Copy your folder's contents into the project root.
2. Fill in the `<PROJECT_NAME>` / `<PROJECT_ROOT>` / `<OWNER>` / `<DATE>` placeholders.
3. Open the project in your agent and trust its hooks.
4. Run both `hooks/verify_*.ps1` checks — they should all pass.
5. Paste the first-session block from `DOCS/STARTUP_MESSAGE.md` into the first chat. (The
   prompts are also collected in [START_HERE.md](START_HERE.md).)

## How recall is forced, not hoped-for

Saving context to a file is the easy half. The hard half is getting the agent to actually look
at it once the conversation has moved on. Telling it "check DECISIONS.md when unsure" is a sign
on the wall — it can walk right past it.

So the templates don't rely on that. Three hooks read your files and push the relevant bits
back into the agent's view at the moments it tends to forget:

```
when                            hook                      what it puts back
────                            ────                      ─────────────────
session starts or compacts      inject_context            CURRENT_STATE + the DEC/REQ/FAIL list
you send a message              inject_on_prompt          the active rules + "read the transcript"
right before an edit            inject_decisions_preedit  the active DEC/REQ rules, at the edit
```

The point: "we use pnpm, not npm" stops depending on the model remembering it. The rule is on
screen at session start, on every message, and again right before the agent writes the install
command. A hook can't be skipped, so the information is guaranteed to be there. And they all
fail safe — if a hook errors it prints nothing and never blocks your session.

## The decision tree

A long project is really a tree of decisions: one goal, a fork with a few options, you pick
one, that becomes the new trunk, it forks again. Markdown is a bad shape for reading that —
a flattened list loses which branch came from which fork. So the template also keeps the
decisions as a tree you can actually look at.

Every real decision the agent makes is appended to `DOCS/_raw/decisions.jsonl` (with the user
message number it came from, the options that were on the table, which was chosen, and the git
commit at that moment). After each turn a hook redraws it as `DOCS/decision_tree.mmd` (renders
on GitHub) and `DOCS/decision_tree.svg` (double-click offline). The drawing is pure scripting —
it costs zero model tokens.

```
ROOT  the main goal (kept intact at the top)
 └─ DEC-001  msg 1
     └─ DEC-002  msg 40   options[memory-only, governance] -> governance
         └─ DEC-003  msg 48   options[instructions, hooks] -> hooks   [a1b2c3]
```

The picture is for you. But it's also how you **direct the agent without ambiguity**. Instead
of "go back to where we decided that thing," you point at a node:

```
You:   "DEC-003 was the wrong call — roll back to it."
Agent: hooks/rollback_to_decision.ps1 -Id DEC-003 -Apply
       → git-reverts to that decision's stored commit, redraws the tree, marks later
         decisions superseded. Deterministic — the commit hash is the single source of truth.
```

You can point by decision id (`-Id DEC-003`) or by message number (`-Msg 48`) — both resolve to
one exact commit, so there's nothing for the agent to guess. (Rollback needs git in the project;
the agent always previews before applying.)

## What's inside each template

```
<root>/
├─ CLAUDE.md / AGENTS.md   the rulebook the agent auto-loads
├─ .claude/ or .codex/     wires up the logging + injection hooks
├─ hooks/
│   ├─ log_user_message.ps1          saves every message word-for-word
│   ├─ inject_context.ps1            re-injects the spine on start / after compaction
│   ├─ inject_on_prompt.ps1          injects active rules with every message
│   ├─ inject_decisions_preedit.ps1  injects active rules right before an edit
│   ├─ verify_project_setup.ps1      checks every required file exists
│   └─ verify_governance.ps1         checks the rules haven't been gutted
└─ DOCS/
   ├─ INDEX.md             map of all docs + which one wins in a conflict
   ├─ CURRENT_STATE.md     what's verified true right now (+ the E0–E5 legend)
   ├─ REQUIREMENTS.md      testable user needs (REQ-XXX)
   ├─ DECISIONS.md         architecture choices and why (DEC-XXX)
   ├─ FAILURE_REGISTRY.md  recurring bugs + the regression test (FAIL-XXX)
   ├─ ANTI_DRIFT_PROTOCOL.md  short loop, three-strike, no silent fallback
   ├─ CHANGE_POLICY.md     raw request → REQ → evidence → one commit → record
   ├─ CHANGE_RECORD_TEMPLATE.md
   ├─ GIT_RUNBOOK.md       safe commit / branch / rollback
   ├─ HANDOVER_RUNBOOK.md  zero-context operator guide
   ├─ STARTUP_MESSAGE.md   prompts to paste at session start
   ├─ BOOTSTRAP_PROMPT.md  prompt to install this system into a fresh project
   ├─ PROJECT_LOG.md       append-only history
   ├─ BUILD_TRACKER.md     status board
   ├─ STATECHART.md        optional visual
   ├─ plans/ changes/ runs/
   └─ _raw/user_messages.txt   exact word-for-word transcript
```

## Optional companion: graphify

The templates remember what you said and decided. They don't map where your code lives. On a
big repo that second kind of memory matters too, and [graphify](https://github.com/safishamsi/graphify)
already does it well — it builds a queryable graph of your code so the agent looks things up
instead of grepping through 200 files.

```
these templates                         graphify
───────────────                         ────────
what did we decide / say / try?         where is the auth code, what calls it?
a diary                                 a map
```

Different jobs, no overlap. If you want both, here's how they fit — but a few things trip
people up, so they're worth spelling out.

### Does graphify auto-fire from these templates?

No. They're separate. Nothing in these templates installs or calls graphify, and copying a
template in does not pull it in.

```
template on its own       graphify isn't there, nothing happens
+ graphify install        the agent starts using the graph during a session
+ graphify hook install   the map rebuilds itself on every git commit
```

graphify only starts doing anything after you run its own commands in a project. It never fires
on its own from this repo.

### Install once, build per project

People run these together as one step and then wonder why the map is stale. They're four
separate things:

```
1. install the tool       once per laptop, forever     uv tool install graphifyy
2. wire it into a project  once per project             graphify install   (or --platform codex)
3. build the first map     once per project             graphify .
4. auto-refresh the map    once per project             graphify hook install
```

Step 4 is the one most people skip, and it's why "install once and it runs itself" is only half
true. The tool installs once. But the map doesn't rebuild on its own until you add the
post-commit hook in step 4 — until then, every code change leaves it a little more out of date.

So per project it's three quick commands:

```
graphify install        # agent uses the graph
graphify .              # build the first map
graphify hook install   # rebuild on every commit, then forget about it
```

Commit the `graphify-out/` folder so teammates start with the map already built, and query it
whenever you want:

```bash
graphify query "what connects auth to the database?"
```

On a real task the two systems hand off cleanly — the template supplies the rules, graphify
supplies the map:

```
"add rate-limiting to the login route"
   ├─ template:  DEC-004 pnpm only · REQ-002 needs an integration test
   └─ graphify:  login route → AuthService → RateLimiter → Redis
```

### Does it cost money?

Building the map is two jobs, and only one of them costs anything.

Reading code structure — functions, files, what calls what — runs locally with tree-sitter.
That's free; nothing leaves your machine. Understanding *meaning* (tying docs and PDFs to code,
naming concepts, summarizing) is sent to an LLM, and that's the part that costs tokens, because
an actual model has to read it.

That split is also why the refresh runs on commit instead of constantly in the background —
each rebuild spends a little on that LLM, so it waits for your commit rather than burning money
while you sleep. You decide when it costs anything. And if you'd rather it cost nothing, point
it at a local model (`--backend ollama`) and even the meaning step stays on your machine.

(graphify is a separate project, not affiliated with this repo. The PyPI package is `graphifyy`
with a double y. Add `graphify-out/cost.json` to your `.gitignore`.)

### You probably don't need the paid step

For "just map my code so the agent finds things fast," the free structural map is enough on its
own. It already answers the questions you actually ask: where is `UserService` defined, what
calls `login()`, what does `auth.ts` import, what breaks if I change this.

The reason the paid meaning layer is mostly redundant is simple — your coding agent is already
a model. It reads the structural map and works out the meaning itself, on the fly. Paying a
second LLM up front to pre-chew that is doing a job your agent does for free as it goes.

What you give up by skipping it: understanding non-code files like PDFs and design docs,
inferred conceptual links that aren't written literally in the code, nicely-named clusters, and
the "why" pulled out of comments. All nice to have, none of it needed to navigate code. It
earns its keep when you've got a lot of docs to tie to the code, or a huge repo where the
connections aren't obvious, or you're onboarding people who need the reasoning. Otherwise:
structural map plus a capable agent is plenty.

## License

MIT. Use it, fork it, ship it.
