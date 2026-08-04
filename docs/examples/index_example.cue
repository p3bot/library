package schemas

// Example index for module discovery
// Keys are bare names of the form "<segment>/<rest>" within their category struct.
// The fully-qualified user-facing address is "<category>:<key>" (e.g. "tasks:review/git-diff").
// Module paths follow the directory structure: github.com/p3bot/library/<category>/<key>@v<n>

index: #Index & {
	agents: {
		"claude/interactive": {
			module:      "github.com/p3bot/library/agents/claude/interactive@v0"
			description: "Anthropic Claude AI agent (interactive mode)"
			tags: ["ai", "anthropic", "claude", "llm"]
			version: "v0.1.0"
			bin:     "claude"
		}

		"gemini/interactive": {
			module:      "github.com/p3bot/library/agents/gemini/interactive@v0"
			description: "Google Gemini AI agent (interactive mode)"
			tags: ["ai", "google", "gemini", "llm"]
			version: "v0.1.0"
			bin:     "gemini"
		}

		"ollama/interactive": {
			module:      "github.com/p3bot/library/agents/ollama/interactive@v0"
			description: "Ollama local LLM runner (interactive mode)"
			tags: ["ai", "ollama", "local", "llm"]
			version: "v0.1.0"
			bin:     "ollama"
		}

		"aichat/interactive": {
			module:      "github.com/p3bot/library/agents/aichat/interactive@v0"
			description: "Multi-provider AI CLI tool (interactive mode)"
			tags: ["ai", "aichat", "multi-provider"]
			version: "v0.1.0"
			bin:     "aichat"
		}
	}

	roles: {
		"golang/assistant": {
			module:      "github.com/p3bot/library/roles/golang/assistant@v0"
			description: "Expert in Go programming language and ecosystem"
			tags: ["golang", "expert", "programming"]
			version: "v0.1.0"
		}

		"review/code-reviewer": {
			module:      "github.com/p3bot/library/roles/review/code-reviewer@v0"
			description: "Code review and quality assurance specialist"
			tags: ["review", "quality", "best-practices"]
			version: "v0.1.0"
		}
	}

	contexts: {
		"cwd/agents-md": {
			module:      "github.com/p3bot/library/contexts/cwd/agents-md@v0"
			description: "Project AGENTS.md (loaded from working directory)"
			tags: ["cwd", "agents", "project"]
			version: "v0.1.0"
		}

		"cwd/dotagents/workspace": {
			module:      "github.com/p3bot/library/contexts/cwd/dotagents/workspace@v0"
			description: "Workspace context from the project's .agents/ directory"
			tags: ["cwd", "dotagents", "workspace"]
			version: "v0.1.0"
		}
	}

	tasks: {
		"review/git-diff": {
			module:      "github.com/p3bot/library/tasks/review/git-diff@v0"
			description: "Review staged git changes before committing"
			tags: ["review", "git", "quality"]
			version: "v0.1.0"
		}

		"golang/lint": {
			module:      "github.com/p3bot/library/tasks/golang/lint@v0"
			description: "Run golangci-lint on the codebase"
			tags: ["golang", "lint", "quality", "static-analysis"]
			version: "v0.1.0"
		}

		"git/pre-commit": {
			module:      "github.com/p3bot/library/tasks/git/pre-commit@v0"
			description: "Run comprehensive pre-commit checks"
			tags: ["git", "hooks", "quality", "ci"]
			version: "v0.1.0"
		}
	}
}

// Example resolution model:
//
// 1. Direct lookup by fully-qualified address (e.g. "tasks:review/git-diff"):
//    - Parse the address into category="tasks" and key="review/git-diff".
//    - Look up index.tasks["review/git-diff"].
//    - Resolve to module path github.com/p3bot/library/tasks/review/git-diff@v0.
//
// 2. Cross-category lookup by bare name (e.g. "review/git-diff"):
//    - Search every category struct for a matching key.
//    - One match: resolve as in (1).
//    - Multiple matches: present candidates as "category:key" so the user can disambiguate.
//
// 3. Search by keyword (e.g. "review"):
//    - Match keyword against keys, descriptions, and tags across all categories.
//    - Single match: resolve as in (1).
//    - Multiple matches: present candidates as "category:key".
//
// 4. Direct module URL (e.g. "github.com/someone/custom-task@v0"):
//    - Detect the registry domain in the input.
//    - Bypass the index and resolve directly against the registry.
