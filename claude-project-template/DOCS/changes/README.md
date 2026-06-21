# changes/ — one record per meaningful change

Each time you make a real change, copy `DOCS/CHANGE_RECORD_TEMPLATE.md` into this folder and
fill it in. Name it:

```
YYYY-MM-DD-REQ-XXX-short-title.md
```

Example: `2026-06-21-REQ-002-stop-blind-retry.md`

This folder is the paper trail: for any change, you can open its record and see the intent,
the files touched, the tests, the commit hash, and how to roll it back.
