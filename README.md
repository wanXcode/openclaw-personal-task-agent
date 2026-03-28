# openclaw-personal-task-agent

A reusable OpenClaw skill for setting up a dedicated personal task-management / GTD child agent.

## What it helps with

This skill helps an OpenClaw agent:
- create or standardize a task-management child agent
- keep runtime prompt files in a repo-backed source-of-truth directory
- map live runtime files by symlink to avoid dual-source drift
- scaffold a live agent shell with task-specific files
- apply human-friendly task-list output rules

## Skill contents

- `SKILL.md` — agent-facing skill instructions
- `references/` — layout and file examples
- `scripts/init_task_agent.sh` — helper script to scaffold a task agent

## Recommended install shape

Place this folder into your OpenClaw workspace skills directory:

```text
<openclaw-workspace>/skills/openclaw-personal-task-agent/
```

OpenClaw will pick it up in the next session.

## One simple install method

Clone this repo, then copy or symlink the folder into your workspace `skills/` directory.

### Minimal install steps

```bash
git clone https://github.com/wanXcode/openclaw-personal-task-agent.git
mkdir -p <openclaw-workspace>/skills/openclaw-personal-task-agent
cp -R openclaw-personal-task-agent/* <openclaw-workspace>/skills/openclaw-personal-task-agent/
```

Then start a new OpenClaw session so the skill can be discovered.

## Example helper script usage

```bash
scripts/init_task_agent.sh --dry-run <repo_root> <agent_name> [live_agents_root]
scripts/init_task_agent.sh <repo_root> <agent_name> [live_agents_root]
scripts/init_task_agent.sh --force <repo_root> <agent_name> [live_agents_root]
```

## Example prompts that should trigger the skill

You can ask OpenClaw things like:

- "Create a dedicated GTD child agent for me"
- "Set up a personal task-management sub-agent in OpenClaw"
- "Turn this task assistant setup into a reusable child agent"
- "Standardize this reminders agent with repo-backed runtime files"
- "Help me package a personal task agent as an installable OpenClaw skill"

## Notes

- This repository is for GitHub distribution, not ClawHub publishing.
- The skill is designed to be reusable across OpenClaw setups.
- Paths inside the skill use placeholders like `<repo>` and `<openclaw-workspace>` where possible.
