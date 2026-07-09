# Agent Patterns

Agent patterns define how an AI CLI tool operates in terms of interactivity and permission handling. Each pattern establishes consistent operational expectations, making agents predictable and fit for purpose.

All agents share the same underlying CLI tool (Claude, Gemini, etc.). The pattern determines the execution mode and permission model.

## Dimensions

Agents vary across two dimensions:

| Dimension | Options |
|-----------|---------|
| Interactivity | Interactive (ongoing session) or Non-interactive (one-shot) |
| Permissions | Default (prompt for approval), Auto-edit (approve file edits), Bypass (approve all) |

## Patterns

### Base

Interactive session with default permission prompts.

- Ongoing conversation with the user
- Prompts for approval before file edits and shell commands
- User remains in control of all actions
- Standard mode for interactive development

Best for: General development, exploratory work, learning a codebase.

### Edit

Interactive session with auto-accepted file edits.

- Ongoing conversation with the user
- Automatically approves file read/write operations
- Still prompts for shell commands and other actions
- Trusted mode for focused editing sessions

Best for: Refactoring, code reviews with fixes, trusted editing tasks.

### Bypass Permissions

Interactive session with all permissions bypassed.

- Ongoing conversation with the user
- Automatically approves all actions (edits, commands, etc.)
- No permission prompts interrupt the workflow
- Full autonomy mode for trusted environments

Best for: Rapid prototyping, trusted environments, experienced users.

### Non-interactive

One-shot execution with default permission prompts.

- Executes the prompt and exits after completion
- Prompts for approval before actions
- No ongoing conversation
- Single task execution mode

Best for: Scripted tasks requiring oversight, CI checks with manual gates.

### Unattended

One-shot execution with all permissions bypassed.

- Executes the prompt and exits after completion
- Automatically approves all actions
- No user interaction required
- Fully autonomous execution mode

Best for: CI/CD pipelines, background tasks, batch operations, scheduled jobs.

## Agent Naming Convention

Agent names follow a consistent pattern within the agents category:

```
<cli-tool>/<variant>
```

The fully-qualified user-facing address is `agents:<cli-tool>/<variant>` (e.g. `agents:claude/interactive`). The table below lists agents by their bare name; prefix with `agents:` for the full address.

| Agent | Interactivity | Permissions |
|-------|---------------|-------------|
| `claude/interactive` | Interactive | Default |
| `claude/edit` | Interactive | Auto-edit |
| `claude/bypass-permissions` | Interactive | Bypass all |
| `claude/non-interactive` | Non-interactive | Default |
| `claude/unattended` | Non-interactive | Bypass all |
| `gemini/interactive` | Interactive | Default |
| `gemini/edit` | Interactive | Auto-edit |
| `gemini/bypass-permissions` | Interactive | Bypass all |
| `gemini/non-interactive` | Non-interactive | Default |
| `gemini/unattended` | Non-interactive | Bypass all |
| `copilot/interactive` | Interactive | Default |
| `copilot/edit` | Interactive | Auto-edit |
| `copilot/bypass-permissions` | Interactive | Bypass all |
| `copilot/non-interactive` | Non-interactive | Default |
| `copilot/unattended` | Non-interactive | Bypass all |
| `grok/interactive` | Interactive | Default |
| `agy/interactive` | Interactive | Default |
| `agy/edit` | Interactive | Auto-edit |
| `agy/bypass-permissions` | Interactive | Bypass all |
| `agy/non-interactive` | Non-interactive | Default |
| `agy/unattended` | Non-interactive | Bypass all |

## Choosing a Pattern

| Situation | Pattern |
|-----------|---------|
| Interactive development | Base |
| Trusted editing session | Edit |
| Full autonomy, interactive | Bypass Permissions |
| Scripted with oversight | Non-interactive |
| Fully automated | Unattended |

Consider:

- **Trust level**: Untrusted environment? Default permissions. Trusted? Edit or Bypass.
- **User presence**: User watching? Interactive. Unattended execution? Non-interactive or Unattended.
- **Task scope**: Exploratory? Interactive. Well-defined? Non-interactive or Unattended.
- **Risk tolerance**: High stakes? Default permissions. Routine automation? Bypass.

## Non-TTY Default-Resolution Contract

If a bin appears in multiple agent index entries, at least one of those entries must end with `/interactive` or be a bare-name key (no slash). This is the non-TTY default-resolution contract: the start binary uses it as a tiebreaker when no human is present to choose a variant.

The contract is enforced by `library/scripts/validate-index`. Run it after any change to `index/index.cue` that adds, removes, or renames an agent entry.

In TTY mode the user always picks a variant from a list, so this contract has no effect on the interactive flow.

## CLI Flag Reference

The patterns map to CLI flags:

| Pattern | Claude Flags | Gemini Flags | Copilot Flags | Grok Flags | Agy Flags |
|---------|--------------|--------------|---------------|------------|-----------|
| Base | `--permission-mode default` | `--approval-mode default --prompt-interactive` | `--interactive` | `--permission-mode default` | `--prompt-interactive` |
| Edit | `--permission-mode acceptEdits` | `--approval-mode auto_edit --prompt-interactive` | `--allow-tool=write --interactive` | — | `--mode accept-edits --prompt-interactive` |
| Bypass Permissions | `--permission-mode bypassPermissions` | `--approval-mode yolo --prompt-interactive` | `--allow-all --interactive` | — | `--dangerously-skip-permissions --prompt-interactive` |
| Non-interactive | `--permission-mode default --print` | `--approval-mode default --prompt` | `--allow-all-tools --prompt` | — | `--print` |
| Unattended | `--permission-mode bypassPermissions --print` | `--approval-mode yolo --prompt` | `--allow-all --prompt` | — | `--dangerously-skip-permissions --print` |

Note: Copilot's "Non-interactive" variant uses `--allow-all-tools` rather than a default-permission flag, so its effective permission posture differs from the Claude and Gemini Non-interactive variants. The pattern label captures the interactivity dimension; consult each agent's `command` field for the exact flags it runs. Only `grok/interactive` is published for Grok so far. Agy has no system-prompt CLI flag; roles rely on workspace `AGENTS.md` / `GEMINI.md` discovery.
