---
name: openclaw-personal-task-agent
description: Create, standardize, or package a personal task-management sub-agent in OpenClaw. Use when the user wants a dedicated GTD/to-do/reminders child agent, wants repo-backed runtime files and live symlink mapping, needs task-agent prompts/guards/output rules, or wants the setup turned into a reusable installable skill.
---

# OpenClaw Personal Task Agent

Use this skill when the user wants a reusable, GitHub-shareable way to configure a dedicated personal task / GTD sub-agent in OpenClaw.

## What this skill does

It standardizes a child-agent setup like AIGTD and is intended to be publishable from GitHub as a reusable OpenClaw skill:
- dedicated agent folder under `workspace/agents/<agent-name>/`
- task-specific prompt / operating guide / memory files
- a repo-backed runtime source-of-truth under a project directory
- optional live-folder symlink mapping to avoid dual-source drift
- task-specific executor / helper script wiring when needed

## When to use

Use this skill when the user asks to:
- create a GTD / to-do / reminders / task-management sub-agent
- turn an existing sub-agent setup into a reusable pattern
- unify child-agent runtime config and live config
- package the setup as an installable skill for future OpenClaw installs

## Bundled resources

- `references/task-agent-runtime-template.md`
  - Read when you want a compact example of source-of-truth vs live layout.
- `references/example-task-agent-files.md`
  - Read when you want starter content for `PROMPT.md`, `OPERATING-GUIDE.md`, and `MEMORY.md`.
- `scripts/init_task_agent.sh`
  - Use when you want a quick scaffold for a new task agent with runtime files linked from repo truth to live dir.
  - It also checks existing symlinks, warns before replacing plain files, and preserves existing live-only shell files.

## Workflow

1. **Clarify the target shape**
   Confirm:
   - agent name
   - task domain (GTD, reminders, project tasks, etc.)
   - source-of-truth repo/directory
   - whether live files should be symlinked to the source of truth
   - whether the agent also owns external integrations such as Apple Reminders sync or scheduled briefings

2. **Create the runtime source of truth**
   Preferred pattern:
   - `<repo>/agent-runtime/<agent-name>/PROMPT.md`
   - `<repo>/agent-runtime/<agent-name>/OPERATING-GUIDE.md`
   - `<repo>/agent-runtime/<agent-name>/MEMORY.md`

   Keep prompt templates that are consumed directly by jobs or scripts in repo paths such as:
   - `<repo>/prompts/*.md`

3. **Create or align the live agent directory**
   Standard live path pattern:
   - `<openclaw-workspace>/agents/<agent-name>/`

   Keep live-only runtime files there, such as:
   - `AGENTS.md`
   - `SOUL.md`
   - `USER.md`
   - `TOOLS.md`
   - caches / runtime state / guard files

4. **Avoid dual-source drift**
   For the core runtime files below, prefer symlinks from live dir to source-of-truth:
   - `PROMPT.md`
   - `OPERATING-GUIDE.md`
   - `MEMORY.md`

   This prevents “repo changed but live copy didn’t”.

   Important nuance for task agents with scheduled jobs:
   - do not assume all prompt-like content is copied into the live agent dir
   - first check whether cron jobs or scripts read repo `prompts/*.md` directly
   - if they do, update the repo prompt source first; a runtime sync script may be unnecessary

5. **Document the ownership model**
   In both the source-of-truth area and live agent area, write the rule clearly:
   - source-of-truth lives in the repo/runtime folder
   - live folder should not become a second manually maintained source
   - sync scripts, if kept, are fallback repair tools rather than daily workflow

6. **If an executor/helper exists, make it real**
   If the task agent depends on scripts such as task executors, ensure commands referenced in prompts actually exist. Do not leave prompts pointing at nonexistent subcommands.

7. **Treat reminders integration as a separate execution layer**
   If the task agent syncs with Apple Reminders, keep the architecture stable and replace only the final execution hop when migrating implementations.

   Preferred pattern proven in a real migration:
   - keep the main orchestrator script unchanged (`scripts/sync_agent_mac.py` style)
   - keep server API / change feed / mapping model unchanged
   - swap only the Mac execution backend behind a stable bridge API

   For EventKit migrations:
   - use a local Swift CLI bridge as the final macOS execution layer
   - keep create / update / move / complete / delete actions stable
   - cut over to EventKit-only only after real-device validation passes
   - archive legacy AppleScript code after references are removed from active paths

8. **Be explicit about tags behavior across surfaces**
   Separate these three cases in docs and prompts:
   - task-system tags in the GTD source data
   - reminder text formatting shown in AIGTD scheduled messages
   - Apple Reminders native tags

   Proven guidance:
   - scheduled reminder text can reliably show all real task tags in rendered source views and prompt templates
   - existing local reminders may need a one-time refresh script to rewrite title/note/list after sync logic changes
   - Apple Reminders native tags should not be promised unless verified on the user's exact macOS flow; EventKit public docs do not expose a clear writable native-tags API

9. **Test one realistic user flow**
   For a task agent, test one concrete interaction such as:
   - “发我全部清单”
   - “帮我记个待办”
   - “看今天任务”
   - “触发一次晨报/晚报”
   - “让本地 Reminders 同步最新字段”

   Validate both:
   - command path works
   - output format is human-friendly rather than raw technical fields
   - scheduled messages use the intended prompt source
   - reminder sync behavior matches the documented guarantees

## Output rules for task agents

When helping build a task-management agent, prefer these defaults:
- avoid Markdown tables for ordinary task-list replies unless the user asks
- separate **task category** from **time bucket**; do not mix them casually
- show human-readable grouped lists first
- avoid exposing raw technical fields (`future`, `q2`, internal IDs) unless needed for debugging
- when discussing tags, distinguish clearly between:
  - source task tags
  - tags rendered into reminder text / note / title
  - Apple Reminders native tags
- do not claim native Reminders tags are supported unless they were verified on the real target flow

## Recommended file layout

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

## Safety / cleanup guidance

- Do not delete runtime caches or guard directories unless you know they are disposable.
- Safe cleanup usually includes:
  - temporary migration backups
  - accidental duplicate copies of core runtime files after symlink cutover
  - throwaway debugging memory files

## Packaging note

If the user wants this reusable across installs or shared by GitHub URL:
- keep the skill focused on structure, ownership rules, and setup flow
- avoid hard-coding one machine’s repo names unless the user explicitly wants a house style
- prefer placeholders like `<repo>` and `<openclaw-workspace>` in documentation
- keep local runtime caches and one-off memories out of the skill package
- make helper scripts safe by default; prefer `--dry-run` support and explicit `--force` for destructive replacement
