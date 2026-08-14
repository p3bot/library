# Index

Module discovery index for the `start` CLI.

Maps friendly names to module paths, enabling CLI search and auto-setup detection.

## Categories

- **agents** - AI CLI tool configurations with `bin` field for PATH detection
- **contexts** - Context documents for prompt composition
- **roles** - System prompt definitions
- **tasks** - Task-specific prompts and workflows
- **skills** - Agent Skills published for install via `start install skills:…`

## Importing

```cue
import "github.com/p3bot/library/index@v1"
```
