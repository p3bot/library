# Agents

Agent definitions for AI CLI tools.

Each module is a CUE package with a command template, supported models, and metadata.

## Structure

Claude Code, Copilot, Antigravity, and Grok are one module. Gemini and AIChat are one module per variant.

```
agents/<tool>/
├── agent.cue
└── cue.mod/module.cue
```

```
agents/<tool>/<variant>/
├── agent.cue
└── cue.mod/module.cue
```

## Available Agents

### claude-code (Anthropic Claude Code)

- [claude-code](claude-code/) - One module. Permission, effort, output, resume, and print are flags

### copilot (GitHub Copilot CLI)

- [copilot](copilot/) - One module. Permission and print are flags

### gemini (Google Gemini CLI)

- [gemini/interactive](gemini/interactive/) - Interactive Gemini session
- [gemini/non-interactive](gemini/non-interactive/) - Non-interactive mode
- [gemini/edit](gemini/edit/) - Auto-accepted file edits
- [gemini/bypass-permissions](gemini/bypass-permissions/) - All permissions bypassed
- [gemini/unattended](gemini/unattended/) - Non-interactive with all permissions bypassed

### aichat (multi-provider CLI)

- [aichat/interactive](aichat/interactive/) - Interactive AIChat session

### grok (xAI Grok Build TUI)

- [grok](grok/) - One module. Permission, effort, output, resume, and print are flags

### agy (Google Antigravity CLI)

- [agy](agy/) - One module. Permission, effort, output, resume, and print are flags

## Documentation

See [docs/](../docs/) for CLI reference documentation.
