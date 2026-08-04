# start CLI Library

Official module library for the [start](https://github.com/p3bot/start) CLI.

The library provides CUE modules for AI agents, roles, contexts, and tasks. Modules are published to the CUE Central Registry under `github.com/p3bot/library` and resolved by the start CLI at runtime.

## Structure

| Directory | Purpose |
| --- | --- |
| [agents/](agents/) | AI CLI tool command templates |
| [roles/](roles/) | System prompt and behaviour definitions |
| [contexts/](contexts/) | Environmental context definitions |
| [tasks/](tasks/) | Task instruction definitions |
| [schemas/](schemas/) | CUE schema definitions |
| [index/](index/) | Module discovery index |
| [docs/](docs/) | Authoring patterns and schema examples |

## Usage

Import a module from the registry:

```cue
import "github.com/p3bot/library/roles/golang/assistant@v0"
```

Modules are normally consumed indirectly through the start CLI:

```
start --role golang/assistant
start task review/git-diff
```

## Address Scheme

User-facing fully-qualified addresses use `category:name`, for example:

```
agents:claude/interactive
roles:golang/assistant
contexts:cwd/agents-md
tasks:review/git-diff
```

Bare names (without the `category:` prefix) work as cross-category lookups. Module paths in CUE imports remain slash-based — the colon scheme applies only to user-facing input and display.

## Documentation

- [contexts/start/library/naming/context.md](contexts/start/library/naming/context.md) - Module naming conventions
- [docs/agent-patterns.md](docs/agent-patterns.md) - Agent authoring patterns
- [docs/role-patterns.md](docs/role-patterns.md) - Role authoring patterns
- [schemas/README.md](schemas/README.md) - Schema reference

## License

[MPL-2.0](LICENSE).
