# Task Agent Runtime Template

Use this as a reference when creating a personal task-management child agent.

## Source-of-truth layout

```text
<repo>/agent-runtime/<agent-name>/
  PROMPT.md
  OPERATING-GUIDE.md
  MEMORY.md
```

## Live agent layout

```text
<openclaw-workspace>/agents/<agent-name>/
  AGENTS.md
  SOUL.md
  USER.md
  TOOLS.md
  PROMPT.md
  OPERATING-GUIDE.md
  MEMORY.md
```

## Suggested ownership

- Repo runtime folder = single source of truth
- Live folder = runtime shell + caches + state
- Core runtime files in live folder should be symlinks to source-of-truth when possible

## Prompt guidance for task agents

Prefer:
- human-readable grouped list replies
- category and time-bucket treated as separate dimensions
- no raw technical table dumps unless debugging
- no internal IDs unless user asks

## Minimal live-only files

Typical live-only files that should stay in the live directory:
- `AGENTS.md`
- `SOUL.md`
- `USER.md`
- `TOOLS.md`
- `readonly-cache/`
- `guard/`
- `.openclaw/`
