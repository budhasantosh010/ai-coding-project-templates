# Architectural decisions

Append-only. Every deliberate "we chose X over Y, because…" gets a stable `DEC-XXX` number, so
future sessions know WHY the code looks the way it does and don't accidentally undo it.

## Decision template

```text
## DEC-XXX — Title

Date:
Status: proposed / accepted / superseded

Context:                (what forced a choice)

Decision:               (what we chose)

Alternatives considered: (what we rejected, and why)

Consequences:           (what this makes easy / hard later)

Verification:           (how we confirmed it works)

Supersedes:             (older DEC-XXX this replaces, if any)
```
