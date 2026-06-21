# Local Git rollback runbook

Git is your safety net: it remembers every version so you can always go back. These are the
only commands you normally need.

## Initialize — only AFTER reviewing `.gitignore`

```powershell
git init -b main
git add -A
git status
git commit -m "chore: establish local project baseline"
```

## Per-task workflow

```powershell
git status --short
git switch -c work/REQ-XXX-short-name
# ... implement and verify ...
git diff
git add <relevant-files>
git commit -m "type(REQ-XXX): concise outcome"
```

## Rollback (safe options first)

```powershell
git restore -- path\to\unwanted-uncommitted-file   # throw away uncommitted edits to one file
git revert <commit>                                # undo a committed change with a NEW commit
git show <commit>:path/to/file                     # peek at an old version without changing anything
```

⚠️ Avoid `git reset --hard` for normal rollback — it destroys work permanently. Prefer
`restore` / `revert`, which are reversible.
