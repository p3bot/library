# Contexts

Context definitions providing environmental information for AI agents.

Each subdirectory contains a CUE package defining a context with structured data about the working environment. Contexts inject relevant information into prompts based on selection behaviour.

## Structure

```
contexts/<scope>/<name>/
├── context.cue
└── cue.mod/module.cue
```

## Selection Behaviour

- `required: true` - Always included in every command
- `default: true` - Included in plain `start`, excluded with explicit `--context`
- `tags` - Included when the matching tag is requested via `--context`

## Available Contexts

### cwd/ (current working directory)

- [cwd/agents-md](cwd/agents-md/) - Repository-specific agent guidelines from `AGENTS.md`
- [cwd/dotagents/workspace](cwd/dotagents/workspace/) - Workspace settings from `./.agents/`
- [cwd/dotagents/context/index](cwd/dotagents/context/index/) - Index of curated reference material in `./.agents/context/`

### home/ (user-home configuration)

- [home/dotagents/environment](home/dotagents/environment/) - Local environment information (user, system, tools)
- [home/dotagents/workflow](home/dotagents/workflow/) - Feature-development workflow
- [home/dotagents/context/index](home/dotagents/context/index/) - Index of curated reference material in `~/.agents/context/`
