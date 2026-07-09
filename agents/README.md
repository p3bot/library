# Agents

Agent definitions for AI CLI tools.

Each subdirectory contains a CUE package defining an agent with its command template, supported models, and metadata.

## Structure

```
agents/<vendor>/<mode>/
├── agent.cue
└── cue.mod/module.cue
```

## Available Agents

### claude/ (Anthropic Claude Code)

- [claude/interactive](claude/interactive/) - Interactive Claude Code session
- [claude/non-interactive](claude/non-interactive/) - Non-interactive mode; completes the task and exits
- [claude/edit](claude/edit/) - Auto-accepted file edits for trusted editing sessions
- [claude/bypass-permissions](claude/bypass-permissions/) - All permissions bypassed for automated tasks
- [claude/unattended](claude/unattended/) - Non-interactive with all permissions bypassed

### copilot/ (GitHub Copilot CLI)

- [copilot/interactive](copilot/interactive/) - Interactive Copilot session
- [copilot/non-interactive](copilot/non-interactive/) - Non-interactive mode
- [copilot/edit](copilot/edit/) - Auto-accepted file edits
- [copilot/bypass-permissions](copilot/bypass-permissions/) - All permissions bypassed
- [copilot/unattended](copilot/unattended/) - Non-interactive with all permissions bypassed

### gemini/ (Google Gemini CLI)

- [gemini/interactive](gemini/interactive/) - Interactive Gemini session
- [gemini/non-interactive](gemini/non-interactive/) - Non-interactive mode
- [gemini/edit](gemini/edit/) - Auto-accepted file edits
- [gemini/bypass-permissions](gemini/bypass-permissions/) - All permissions bypassed
- [gemini/unattended](gemini/unattended/) - Non-interactive with all permissions bypassed

### aichat/ (multi-provider CLI)

- [aichat/interactive](aichat/interactive/) - Interactive AIChat session

### grok/ (xAI Grok Build TUI)

- [grok/interactive](grok/interactive/) - Interactive Grok Build session

### agy/ (Google Antigravity CLI)

- [agy/interactive](agy/interactive/) - Interactive Antigravity session
- [agy/non-interactive](agy/non-interactive/) - Non-interactive mode
- [agy/edit](agy/edit/) - Auto-accepted file edits via --mode accept-edits
- [agy/bypass-permissions](agy/bypass-permissions/) - All permissions bypassed
- [agy/unattended](agy/unattended/) - Non-interactive with all permissions bypassed

## Documentation

See [docs/](../docs/) for CLI reference documentation.
