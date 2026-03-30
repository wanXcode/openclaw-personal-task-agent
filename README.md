# openclaw-personal-task-agent

A reusable OpenClaw skill for creating, standardizing, and packaging a dedicated personal task-management / GTD child agent.

This skill is useful when you want an agent that owns personal tasks, reminders, daily briefings, or GTD-style workflows — while keeping the runtime files organized, repo-backed, and shareable.

## What this skill helps with

It helps an OpenClaw agent:

- create a dedicated task / GTD child agent
- standardize an existing reminders or todo agent into a reusable pattern
- keep a repo-backed source of truth for core runtime files
- map live runtime files by symlink to avoid dual-source drift
- scaffold a task-agent shell with practical starter files
- document output rules for human-friendly task replies
- preserve separation between task tags, rendered reminder text, and platform-native reminder capabilities

## Included files

- `SKILL.md` — the main agent-facing instructions
- `references/task-agent-runtime-template.md` — example layout for source-of-truth vs live runtime files
- `references/example-task-agent-files.md` — starter content ideas for prompt/guide/memory files
- `scripts/init_task_agent.sh` — helper script to scaffold a task agent and optionally wire symlinks safely
- `openclaw-personal-task-agent.skill` — packaged skill artifact for distribution

## Best fit use cases

Use this skill when the user wants to:

- create a GTD / to-do / reminders child agent
- turn an existing task bot into a reusable OpenClaw setup
- unify repo config and live runtime config
- package a task-management setup as a reusable skill
- keep scheduled task prompts and runtime behavior maintainable over time

## Recommended layout

```text
<repo>/agent-runtime/<agent-name>/
  PROMPT.md
  OPERATING-GUIDE.md
  MEMORY.md

<openclaw-workspace>/agents/<agent-name>/
  AGENTS.md
  SOUL.md
  USER.md
  TOOLS.md
  PROMPT.md -> symlink to source-of-truth
  OPERATING-GUIDE.md -> symlink to source-of-truth
  MEMORY.md -> symlink to source-of-truth
```

This pattern keeps the editable source in the repo while preventing the live agent folder from drifting into a second manual source of truth.

## Installation

### Option 1: install from this repository

Clone the repository and place it into your OpenClaw workspace skills directory:

```bash
git clone https://github.com/wanXcode/openclaw-personal-task-agent.git
mkdir -p <openclaw-workspace>/skills/openclaw-personal-task-agent
cp -R openclaw-personal-task-agent/* <openclaw-workspace>/skills/openclaw-personal-task-agent/
```

Then start a new OpenClaw session so the skill can be discovered.

### Option 2: install from the packaged `.skill` file

Use the packaged artifact from GitHub Releases:

- `openclaw-personal-task-agent.skill`

This is useful when you want a simpler distribution artifact instead of cloning the repo.

## Helper script usage

The included script can scaffold a task agent and help wire the live directory to repo-backed runtime files.

```bash
scripts/init_task_agent.sh --dry-run <repo_root> <agent_name> [live_agents_root]
scripts/init_task_agent.sh <repo_root> <agent_name> [live_agents_root]
scripts/init_task_agent.sh --force <repo_root> <agent_name> [live_agents_root]
```

### What the helper script is for

It is designed to:

- create the runtime source-of-truth folder
- create or align the live agent folder
- set up symlinks for core runtime files
- warn before replacing plain files
- preserve live-only shell files where appropriate

## Example prompts that should trigger the skill

You can ask OpenClaw things like:

- "Create a dedicated GTD child agent for me"
- "Set up a personal task-management sub-agent in OpenClaw"
- "Turn this task assistant setup into a reusable child agent"
- "Standardize this reminders agent with repo-backed runtime files"
- "Help me package a personal task agent as an installable OpenClaw skill"

## Design principles in this skill

This skill is opinionated in a few useful ways:

- core runtime files should have a clear source of truth
- live runtime folders should not silently diverge from repo state
- prompts should not reference nonexistent scripts or commands
- task output should be human-friendly first, technical second
- reminder text formatting and native reminder platform features should not be conflated
- integrations such as Apple Reminders sync should be treated as a separate execution layer

## Notes

- This repository is intended for GitHub distribution and reuse.
- The packaged `.skill` file is suitable for release attachment and sharing.
- The skill intentionally uses placeholders like `<repo>` and `<openclaw-workspace>` to stay reusable across setups.
- Local caches, private runtime state, and one-off machine-specific data should stay out of the published skill.
