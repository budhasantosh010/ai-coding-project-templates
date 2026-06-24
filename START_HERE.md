# START HERE 👋

**What is this?** A folder you drop into your coding project so your AI assistant
(Claude Code or OpenAI Codex) **stops forgetting things.** Normally the AI forgets what you
told it the moment a chat gets long or you start a new session. This fixes that — automatically,
for free, without you doing anything special.

Think of it like giving your AI a **notebook + a map** that it can never lose.

---

## Will this help me? (read this first)

```
Have you ever...
  • told the AI "we use pnpm, not npm" — and next time it used npm anyway?
  • explained your whole project again because the AI "forgot"?
  • watched the AI get dumber/sloppier the longer a chat went on?
  • wished you could see WHICH decisions you made and go back to one?

If you nodded at ANY of these → this is for you. Keep reading. It takes 5 minutes to set up.
```

---

## Setup — just follow the steps in order 🪜

### STEP 1 — Pick your folder

```
Do you use Claude Code?   →  use the folder:  claude-project-template
Do you use OpenAI Codex?  →  use the folder:  codex-project-template
Not sure?                 →  whichever AI coding tool you type into. Most people: Claude Code.
```

### STEP 2 — Copy it into YOUR project

Copy **everything inside** your chosen folder into the top of your own project folder.
After copying, your project should contain a `CLAUDE.md` (or `AGENTS.md`), a `hooks` folder,
and a `DOCS` folder.

### STEP 3 — Fill in the blanks

A few files have placeholders like `<PROJECT_NAME>` and `<PROJECT_ROOT>`. Open them and replace
those with your real project name and folder path. (Your AI can do this for you — just ask it:
*"replace the placeholders in this template with my project's real details."*)

### STEP 4 — (Optional but recommended) Turn on "smart memory"

This one extra power lets the AI find old notes **by meaning**, not just exact words
(so asking about "login" can find notes about "authentication"). One command, one time, per computer:

```
uv pip install sentence-transformers
   (or, if that errors:)   pip install --user sentence-transformers
```

If you skip this, **everything still works** — the AI just searches by exact words instead of meaning.

### STEP 5 — Start your AI and paste the magic first message

Open your project in Claude Code or Codex, and paste the **FIRST-SESSION prompt** from the next
section. That's it. From now on the AI remembers everything, follows your rules, and draws you
a map of every decision.

---

## The magic messages to paste 🎤

> These are the things you literally copy-paste to the AI. There are three, for three moments.
> The ONLY difference between Claude and Codex is one filename: Claude reads `CLAUDE.md`,
> Codex reads `AGENTS.md`. Below it's written as `[CLAUDE.md / AGENTS.md]` — keep the one for your tool.

### 🟢 The VERY FIRST time (right after Step 4)

```text
Before doing anything else, set up and prove the project memory system.

Project root: <PROJECT_ROOT>

1. Read these in order: [CLAUDE.md / AGENTS.md], DOCS/INDEX.md, DOCS/CURRENT_STATE.md,
   DOCS/REQUIREMENTS.md, DOCS/HANDOVER_RUNBOOK.md, DOCS/BUILD_TRACKER.md, the newest
   DOCS/PROJECT_LOG.md entries, the active DOCS/plans/ plan, and DOCS/DECISIONS.md +
   DOCS/FAILURE_REGISTRY.md.
2. Run hooks/verify_project_setup.ps1 and hooks/verify_governance.ps1 and show me the result.
3. Confirm the message-logging hook is on (this message should appear once in
   DOCS/_raw/user_messages.txt).
4. Tell me: what's the project's MAIN GOAL, what's left to fill in (placeholders), and the Git state.

Do NOT start building yet. First prove the memory + safety system is working, then wait for me.
```

### 🔵 EVERY time you start a NEW chat after that

```text
Reload the project context required by [CLAUDE.md / AGENTS.md] and DOCS/INDEX.md, and follow
DOCS/ANTI_DRIFT_PROTOCOL.md and DOCS/CHANGE_POLICY.md.

Before you edit anything: tell me the active goal, what must NOT change, how we'll know it works,
and the current Git branch. Work on ONE thing at a time. If the same thing fails 3 times, STOP
and diagnose. Never pretend something works when it doesn't.

First, tell me where we left off and the smallest next step.
```

### ⚪ When you want it to actually BUILD something

```text
Go ahead with the next step in the active plan. Write a quick test first, make the smallest
change, run the test, show me the result, make one commit, and update the notes. Then tell me
what you did, proof it works, and what's next.
```

---

## What you get (in plain words) 🎁

```
📓 IT REMEMBERS         every message you send is saved word-for-word, forever
🧠 IT DOESN'T DRIFT     your rules get re-shown to the AI every session + before every edit,
                        so it can't "forget" that you use pnpm not npm
🔎 IT CAN LOOK THINGS UP ask "what did we decide about X?" and it finds it (by meaning, if Step 4 done)
                        — and if it doesn't know, it SAYS SO instead of making something up
🌳 IT DRAWS A MAP       every decision becomes a tree you can see (DOCS/decision_tree/...)
⏪ YOU CAN GO BACK      say "that decision was wrong, roll back to it" → it rewinds the code
✅ "DONE" MEANS DONE    it won't claim success without proof (a passing test or a real run)
```

All of this runs by itself in the background. It costs **$0 in AI tokens** (plain code does the
work, not the AI). You just talk to your AI normally.

---

## "Which file is what?" (only if you're curious) 🗂️

```
CLAUDE.md / AGENTS.md   the rulebook your AI reads automatically
hooks/                  little background scripts that do the remembering (you never run these by hand)
DOCS/
  INDEX.md              the table of contents (start here if lost)
  CURRENT_STATE.md      what's true right now
  DECISIONS.md          the choices you made and why
  decision_tree/        picture of every decision (open the .svg files)
  decision_tree.txt     the same map as text
  PROJECT_LOG.md        the diary of everything that happened
  _raw/user_messages.txt every message you ever sent, word-for-word
```

You almost never need to open these — the AI manages them. They're there so nothing is ever lost.

---

## Trouble? 🆘

```
"It threw a red error about scripts"  → make sure you copied the WHOLE command (it includes a
                                         safety flag). On Windows, that's normal — the flag handles it.
"Semantic search isn't working"        → did you do Step 4? It's optional; without it, search still
                                         works by exact words.
"I don't see the decision map"         → the AI draws it after it makes a real decision. Make one
                                         decision with it, then check the DOCS/decision_tree/ folder.
```

---

Pick your folder, copy it in, paste the first message. That's the whole thing. Welcome aboard. 🚢
