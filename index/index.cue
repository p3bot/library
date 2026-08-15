package index

import "github.com/p3bot/library/schemas@v1"

// Agent index - maps friendly names to module paths with bin for detection
agents: [string]: schemas.#IndexEntry

agents: {
	"claude/interactive": {
		module:      "github.com/p3bot/library/agents/claude/interactive@v1"
		version:     "v1.1.0"
		description: "Claude Code by Anthropic - agentic coding assistant"
		bin:         "claude"
		tags: ["anthropic", "claude", "coding", "agent"]
	}
	"claude/bypass-permissions": {
		module:      "github.com/p3bot/library/agents/claude/bypass-permissions@v1"
		version:     "v1.1.0"
		description: "Claude Code with all permissions bypassed - for background and automated tasks"
		bin:         "claude"
		tags: ["anthropic", "claude", "coding", "agent", "automation", "background", "bypass-permissions"]
	}
	"claude/edit": {
		module:      "github.com/p3bot/library/agents/claude/edit@v1"
		version:     "v1.1.0"
		description: "Claude Code with auto-accepted file edits - for trusted editing sessions"
		bin:         "claude"
		tags: ["anthropic", "claude", "coding", "agent", "trusted", "auto-edit"]
	}
	"claude/non-interactive": {
		module:      "github.com/p3bot/library/agents/claude/non-interactive@v1"
		version:     "v1.1.0"
		description: "Claude Code in non-interactive mode - completes task and exits"
		bin:         "claude"
		tags: ["anthropic", "claude", "coding", "agent", "non-interactive", "scripted"]
	}
	"claude/unattended": {
		module:      "github.com/p3bot/library/agents/claude/unattended@v1"
		version:     "v1.1.0"
		description: "Claude Code in unattended mode - non-interactive with all permissions bypassed"
		bin:         "claude"
		tags: ["anthropic", "claude", "coding", "agent", "unattended", "non-interactive", "bypass-permissions", "automation"]
	}
	"gemini/interactive": {
		module:      "github.com/p3bot/library/agents/gemini/interactive@v1"
		version:     "v1.0.0"
		description: "Gemini CLI by Google - agentic coding assistant"
		bin:         "gemini"
		tags: ["google", "gemini", "coding", "agent"]
	}
	"gemini/bypass-permissions": {
		module:      "github.com/p3bot/library/agents/gemini/bypass-permissions@v1"
		version:     "v1.0.0"
		description: "Gemini CLI with all approvals bypassed - for background and automated tasks"
		bin:         "gemini"
		tags: ["google", "gemini", "coding", "agent", "automation", "background", "bypass-permissions"]
	}
	"gemini/edit": {
		module:      "github.com/p3bot/library/agents/gemini/edit@v1"
		version:     "v1.0.0"
		description: "Gemini CLI with auto-accepted file edits - for trusted editing sessions"
		bin:         "gemini"
		tags: ["google", "gemini", "coding", "agent", "trusted", "auto-edit"]
	}
	"gemini/non-interactive": {
		module:      "github.com/p3bot/library/agents/gemini/non-interactive@v1"
		version:     "v1.0.0"
		description: "Gemini CLI in non-interactive mode - completes task and exits"
		bin:         "gemini"
		tags: ["google", "gemini", "coding", "agent", "non-interactive", "scripted"]
	}
	"gemini/unattended": {
		module:      "github.com/p3bot/library/agents/gemini/unattended@v1"
		version:     "v1.0.0"
		description: "Gemini CLI in unattended mode - non-interactive with all approvals bypassed"
		bin:         "gemini"
		tags: ["google", "gemini", "coding", "agent", "unattended", "non-interactive", "bypass-permissions", "automation"]
	}
	"aichat/interactive": {
		module:      "github.com/p3bot/library/agents/aichat/interactive@v1"
		version:     "v1.0.0"
		description: "AIChat - All-in-one LLM CLI tool by sigoden"
		bin:         "aichat"
		tags: ["aichat", "multi-provider", "rag", "agents"]
	}
	"copilot/interactive": {
		module:      "github.com/p3bot/library/agents/copilot/interactive@v1"
		version:     "v1.0.0"
		description: "GitHub Copilot CLI - agentic coding assistant"
		bin:         "copilot"
		tags: ["github", "copilot", "coding", "agent"]
	}
	"copilot/edit": {
		module:      "github.com/p3bot/library/agents/copilot/edit@v1"
		version:     "v1.0.0"
		description: "GitHub Copilot CLI with auto-accepted file edits - for trusted editing sessions"
		bin:         "copilot"
		tags: ["github", "copilot", "coding", "agent", "trusted", "auto-edit"]
	}
	"copilot/bypass-permissions": {
		module:      "github.com/p3bot/library/agents/copilot/bypass-permissions@v1"
		version:     "v1.0.0"
		description: "GitHub Copilot CLI with all permissions bypassed - for background and automated tasks"
		bin:         "copilot"
		tags: ["github", "copilot", "coding", "agent", "automation", "background", "bypass-permissions"]
	}
	"copilot/non-interactive": {
		module:      "github.com/p3bot/library/agents/copilot/non-interactive@v1"
		version:     "v1.0.0"
		description: "GitHub Copilot CLI in non-interactive mode - completes task and exits"
		bin:         "copilot"
		tags: ["github", "copilot", "coding", "agent", "non-interactive", "scripted"]
	}
	"copilot/unattended": {
		module:      "github.com/p3bot/library/agents/copilot/unattended@v1"
		version:     "v1.0.0"
		description: "GitHub Copilot CLI in unattended mode - non-interactive with all permissions bypassed"
		bin:         "copilot"
		tags: ["github", "copilot", "coding", "agent", "unattended", "non-interactive", "bypass-permissions", "automation"]
	}
	"grok/interactive": {
		module:      "github.com/p3bot/library/agents/grok/interactive@v1"
		version:     "v1.1.0"
		description: "Grok Build TUI by xAI - agentic coding assistant"
		bin:         "grok"
		tags: ["xai", "grok", "coding", "agent"]
	}
	"grok/auto": {
		module:      "github.com/p3bot/library/agents/grok/auto@v1"
		version:     "v1.0.0"
		description: "Grok Build TUI with auto permission mode - fewer prompts with background safety checks"
		bin:         "grok"
		tags: ["xai", "grok", "coding", "agent", "auto"]
	}
	"agy/interactive": {
		module:      "github.com/p3bot/library/agents/agy/interactive@v1"
		version:     "v1.1.0"
		description: "Antigravity CLI by Google - agentic coding assistant"
		bin:         "agy"
		tags: ["google", "agy", "antigravity", "coding", "agent"]
	}
	"agy/edit": {
		module:      "github.com/p3bot/library/agents/agy/edit@v1"
		version:     "v1.1.0"
		description: "Antigravity CLI with auto-accepted file edits - for trusted editing sessions"
		bin:         "agy"
		tags: ["google", "agy", "antigravity", "coding", "agent", "trusted", "auto-edit"]
	}
	"agy/bypass-permissions": {
		module:      "github.com/p3bot/library/agents/agy/bypass-permissions@v1"
		version:     "v1.1.0"
		description: "Antigravity CLI with all permissions bypassed - for background and automated tasks"
		bin:         "agy"
		tags: ["google", "agy", "antigravity", "coding", "agent", "automation", "background", "bypass-permissions"]
	}
	"agy/non-interactive": {
		module:      "github.com/p3bot/library/agents/agy/non-interactive@v1"
		version:     "v1.1.0"
		description: "Antigravity CLI in non-interactive mode - completes task and exits"
		bin:         "agy"
		tags: ["google", "agy", "antigravity", "coding", "agent", "non-interactive", "scripted"]
	}
	"agy/unattended": {
		module:      "github.com/p3bot/library/agents/agy/unattended@v1"
		version:     "v1.1.0"
		description: "Antigravity CLI in unattended mode - non-interactive with all permissions bypassed"
		bin:         "agy"
		tags: ["google", "agy", "antigravity", "coding", "agent", "unattended", "non-interactive", "bypass-permissions", "automation"]
	}
}

// Role index - maps friendly names to module paths
roles: [string]: schemas.#IndexEntry

roles: {
	"golang/agent": {
		module:      "github.com/p3bot/library/roles/golang/agent@v1"
		version:     "v1.0.0"
		description: "Go programming language expert - autonomous agent mode"
		tags: ["golang", "programming", "agent", "autonomous", "automation"]
	}
	"golang/assistant": {
		module:      "github.com/p3bot/library/roles/golang/assistant@v1"
		version:     "v1.0.0"
		description: "Go programming language expert - collaborative assistant mode"
		tags: ["golang", "programming", "assistant", "collaborative"]
	}
	"golang/teacher": {
		module:      "github.com/p3bot/library/roles/golang/teacher@v1"
		version:     "v1.0.0"
		description: "Go programming language expert - instructional teacher mode"
		tags: ["golang", "programming", "teacher", "instructional", "learning"]
	}
	"start/library/agent": {
		module:      "github.com/p3bot/library/roles/start/library/agent@v1"
		version:     "v1.0.0"
		description: "library expert - autonomous agent mode"
		tags: ["library", "cue", "agent", "autonomous"]
	}
	"start/library/assistant": {
		module:      "github.com/p3bot/library/roles/start/library/assistant@v1"
		version:     "v1.0.0"
		description: "library expert - collaborative assistant mode"
		tags: ["library", "cue", "assistant", "collaborative"]
	}
	"start/library/teacher": {
		module:      "github.com/p3bot/library/roles/start/library/teacher@v1"
		version:     "v1.0.0"
		description: "library expert - educational teacher mode"
		tags: ["library", "cue", "teacher", "educational"]
	}
	"home/dotagents/default": {
		module:      "github.com/p3bot/library/roles/home/dotagents/default@v1"
		version:     "v1.0.0"
		description: "User's global default role from ~/.agents/roles/default.md"
		tags: ["dotagents", "home", "global", "default"]
	}
	"cwd/dotagents/default": {
		module:      "github.com/p3bot/library/roles/cwd/dotagents/default@v1"
		version:     "v1.0.0"
		description: "Project-specific default role from .agents/roles/default.md"
		tags: ["dotagents", "cwd", "project", "default"]
	}
	"cwd/role-md": {
		module:      "github.com/p3bot/library/roles/cwd/role-md@v1"
		version:     "v1.0.0"
		description: "Project-specific role from role.md"
		tags: ["cwd", "project", "role"]
	}
	"markdown/low-token/agent": {
		module:      "github.com/p3bot/library/roles/markdown/low-token/agent@v1"
		version:     "v1.0.0"
		description: "Low-token markdown expert - autonomous agent mode"
		tags: ["markdown", "low-token", "commonmark", "agent", "autonomous"]
	}
	"markdown/low-token/assistant": {
		module:      "github.com/p3bot/library/roles/markdown/low-token/assistant@v1"
		version:     "v1.0.0"
		description: "Low-token markdown expert - collaborative assistant mode"
		tags: ["markdown", "low-token", "commonmark", "assistant", "collaborative"]
	}
	"markdown/low-token/teacher": {
		module:      "github.com/p3bot/library/roles/markdown/low-token/teacher@v1"
		version:     "v1.0.0"
		description: "Low-token markdown expert - instructional teacher mode"
		tags: ["markdown", "low-token", "commonmark", "teacher", "instructional"]
	}
	"gitlab/pipeline/agent": {
		module:      "github.com/p3bot/library/roles/gitlab/pipeline/agent@v1"
		version:     "v1.0.0"
		description: "GitLab CI/CD pipeline expert - autonomous agent mode"
		tags: ["gitlab", "ci-cd", "pipeline", "agent", "autonomous"]
	}
	"gitlab/pipeline/assistant": {
		module:      "github.com/p3bot/library/roles/gitlab/pipeline/assistant@v1"
		version:     "v1.0.0"
		description: "GitLab CI/CD pipeline expert - collaborative assistant mode"
		tags: ["gitlab", "ci-cd", "pipeline", "assistant", "collaborative"]
	}
	"gitlab/pipeline/teacher": {
		module:      "github.com/p3bot/library/roles/gitlab/pipeline/teacher@v1"
		version:     "v1.0.0"
		description: "GitLab CI/CD pipeline expert - instructional teacher mode"
		tags: ["gitlab", "ci-cd", "pipeline", "teacher", "instructional"]
	}
	"git/agent": {
		module:      "github.com/p3bot/library/roles/git/agent@v1"
		version:     "v1.0.0"
		description: "Git version control expert - autonomous agent mode"
		tags: ["git", "version-control", "vcs", "agent", "autonomous"]
	}
	"git/assistant": {
		module:      "github.com/p3bot/library/roles/git/assistant@v1"
		version:     "v1.0.0"
		description: "Git version control expert - collaborative assistant mode"
		tags: ["git", "version-control", "vcs", "assistant", "collaborative"]
	}
	"git/teacher": {
		module:      "github.com/p3bot/library/roles/git/teacher@v1"
		version:     "v1.0.0"
		description: "Git version control expert - instructional teacher mode"
		tags: ["git", "version-control", "vcs", "teacher", "instructional", "learning"]
	}
	"linux/endeavouros/agent": {
		module:      "github.com/p3bot/library/roles/linux/endeavouros/agent@v1"
		version:     "v1.0.0"
		description: "EndeavourOS Linux system administration expert - autonomous agent mode"
		tags: ["linux", "endeavouros", "arch", "system-administration", "agent", "autonomous"]
	}
	"linux/endeavouros/assistant": {
		module:      "github.com/p3bot/library/roles/linux/endeavouros/assistant@v1"
		version:     "v1.0.0"
		description: "EndeavourOS Linux system administration expert - collaborative assistant mode"
		tags: ["linux", "endeavouros", "arch", "system-administration", "assistant", "collaborative"]
	}
	"linux/endeavouros/teacher": {
		module:      "github.com/p3bot/library/roles/linux/endeavouros/teacher@v1"
		version:     "v1.0.0"
		description: "EndeavourOS Linux system administration expert - instructional teacher mode"
		tags: ["linux", "endeavouros", "arch", "system-administration", "teacher", "instructional", "learning"]
	}
	"role/design/agent": {
		module:      "github.com/p3bot/library/roles/role/design/agent@v1"
		version:     "v1.0.0"
		description: "AI role designer and prompt engineering expert - autonomous agent mode"
		tags: ["role", "prompt-engineering", "design", "agent", "autonomous"]
	}
	"role/design/assistant": {
		module:      "github.com/p3bot/library/roles/role/design/assistant@v1"
		version:     "v1.0.0"
		description: "AI role designer and prompt engineering expert - collaborative assistant mode"
		tags: ["role", "prompt-engineering", "design", "assistant", "collaborative"]
	}
	"role/design/teacher": {
		module:      "github.com/p3bot/library/roles/role/design/teacher@v1"
		version:     "v1.0.0"
		description: "AI role designer and prompt engineering expert - instructional teacher mode"
		tags: ["role", "prompt-engineering", "design", "teacher", "instructional", "learning"]
	}
}

// Context index - maps friendly names to module paths
contexts: [string]: schemas.#IndexEntry

contexts: {
	"cwd/agents-md": {
		module:      "github.com/p3bot/library/contexts/cwd/agents-md@v1"
		version:     "v1.1.0"
		description: "Repository introduction from AGENTS.md"
		tags: ["agents", "repository", "cwd"]
	}
	"home/dotagents/environment": {
		module:      "github.com/p3bot/library/contexts/home/dotagents/environment@v1"
		version:     "v1.0.0"
		description: "Local environment information including user, system, and tool context"
		tags: ["dotagents", "home", "environment", "system", "user"]
	}
	"home/dotagents/workflow": {
		module:      "github.com/p3bot/library/contexts/home/dotagents/workflow@v1"
		version:     "v1.0.0"
		description: "Feature development workflow for Documentation Driven Development"
		tags: ["dotagents", "home", "workflow", "development"]
	}
	"home/dotagents/context/index": {
		module:      "github.com/p3bot/library/contexts/home/dotagents/context/index@v1"
		version:     "v1.0.0"
		description: "Index of curated reference material in ~/.agents/context/"
		tags: ["dotagents", "home", "context", "index", "reference"]
	}
	"cwd/dotagents/context/index": {
		module:      "github.com/p3bot/library/contexts/cwd/dotagents/context/index@v1"
		version:     "v1.0.0"
		description: "Index of curated reference material in .agents/context/"
		tags: ["dotagents", "cwd", "context", "index", "reference"]
	}
	"cwd/dotagents/workspace": {
		module:      "github.com/p3bot/library/contexts/cwd/dotagents/workspace@v1"
		version:     "v1.0.0"
		description: "Workspace context from .agents/workspace.md"
		tags: ["dotagents", "cwd", "workspace"]
	}
	"cli/design": {
		module:      "github.com/p3bot/library/contexts/cli/design@v1"
		version:     "v1.0.0"
		description: "Agent-first CLI design guide for designing and auditing command-line tools"
		tags: ["cli", "design", "agents", "guide"]
	}
	"golang/design/cli": {
		module:      "github.com/p3bot/library/contexts/golang/design/cli@v1"
		version:     "v1.0.0"
		description: "Go CLI design guide: architecture, patterns, and conventions for command-line tools"
		tags: ["golang", "design", "cli", "go", "guide"]
	}
	"ticket/writing": {
		module:      "github.com/p3bot/library/contexts/ticket/writing@v1"
		version:     "v1.0.0"
		description: "Guide for writing ticket documents that serve as the sole context for an implementer agent"
		tags: ["ticket", "writing", "documentation", "guide", "agents"]
	}
	"ticket/implementation": {
		module:      "github.com/p3bot/library/contexts/ticket/implementation@v1"
		version:     "v1.0.0"
		description: "Guide for implementing ticket documents received as the sole context for the work"
		tags: ["ticket", "implementation", "implement", "implementing", "execution", "delivery", "documentation", "guide", "agents"]
	}
	"design/writing": {
		module:      "github.com/p3bot/library/contexts/design/writing@v1"
		version:     "v1.1.0"
		description: "Guide for writing design documents for a new system or substantial feature before decomposition into ticket documents"
		tags: ["design", "writing", "feature", "architecture", "documentation", "guide", "agents"]
	}
	"start/library/naming": {
		module:      "github.com/p3bot/library/contexts/start/library/naming@v1"
		version:     "v1.2.0"
		description: "Naming conventions for all module types in the p3bot library"
		tags: ["start", "library", "naming", "conventions", "standards", "modules", "guide"]
	}
	"start/library/publishing": {
		module:      "github.com/p3bot/library/contexts/start/library/publishing@v1"
		version:     "v1.1.0"
		description: "Canonical workflow for publishing library modules to the CUE Central Registry"
		tags: ["start", "library", "publishing", "publish", "release", "registry", "workflow", "guide"]
	}
}

// Task index - maps friendly names to module paths
tasks: [string]: schemas.#IndexEntry

tasks: {
	"claude/statusline/create": {
		module:      "github.com/p3bot/library/tasks/claude/statusline/create@v1"
		version:     "v1.0.0"
		description: "Install the Claude Code statusline script and wire it into settings.json"
		tags: ["claude", "statusline", "configuration", "settings", "shell"]
	}
	"claude/statusline/update": {
		module:      "github.com/p3bot/library/tasks/claude/statusline/update@v1"
		version:     "v1.0.0"
		description: "Interactively customise the Claude Code statusline script"
		tags: ["claude", "statusline", "customise", "interactive", "settings"]
	}
	"golang/debug": {
		module:      "github.com/p3bot/library/tasks/golang/debug@v1"
		version:     "v1.0.0"
		description: "Systematically debug and resolve issues in Go code"
		tags: ["golang", "debug", "troubleshooting", "bugs", "investigation"]
	}
	"golang/release/github-homebrew": {
		module:      "github.com/p3bot/library/tasks/golang/release/github-homebrew@v1"
		version:     "v1.0.0"
		description: "Release Go project to GitHub with Homebrew tap distribution"
		tags: ["golang", "release", "github", "homebrew", "ci-cd"]
	}
	"golang/refactor": {
		module:      "github.com/p3bot/library/tasks/golang/refactor@v1"
		version:     "v1.0.0"
		description: "Refactor Go code to improve structure, readability, and maintainability"
		tags: ["golang", "refactor", "code-quality", "maintainability", "structure"]
	}
	"review/holistic": {
		module:      "github.com/p3bot/library/tasks/review/holistic@v1"
		version:     "v1.0.0"
		description: "Broad first-pass review assessing overall repository health, consistency, and structure"
		tags: ["review", "holistic", "code-quality", "repository", "comprehensive"]
	}
	"review/security": {
		module:      "github.com/p3bot/library/tasks/review/security@v1"
		version:     "v1.0.0"
		description: "Identify vulnerabilities, security weaknesses, and potential attack vectors"
		tags: ["review", "security", "vulnerabilities", "attack-vectors", "code-quality"]
	}
	"review/correctness": {
		module:      "github.com/p3bot/library/tasks/review/correctness@v1"
		version:     "v1.0.0"
		description: "Verify code logic correctly implements intended behaviour and handles data with precision"
		tags: ["review", "correctness", "logic", "behaviour", "code-quality"]
	}
	"review/architecture": {
		module:      "github.com/p3bot/library/tasks/review/architecture@v1"
		version:     "v1.0.0"
		description: "Evaluate system structure, design decisions, and component organisation"
		tags: ["review", "architecture", "design", "structure", "code-quality"]
	}
	"review/comments": {
		module:      "github.com/p3bot/library/tasks/review/comments@v1"
		version:     "v1.0.0"
		description: "Review code comments for accuracy, usefulness, and completeness"
		tags: ["review", "comments", "documentation", "code-quality"]
	}
	"review/concurrency": {
		module:      "github.com/p3bot/library/tasks/review/concurrency@v1"
		version:     "v1.0.0"
		description: "Identify threading, parallelism, and asynchronous execution issues"
		tags: ["review", "concurrency", "threading", "parallelism", "code-quality"]
	}
	"review/performance": {
		module:      "github.com/p3bot/library/tasks/review/performance@v1"
		version:     "v1.0.0"
		description: "Analyse code efficiency and resource usage"
		tags: ["review", "performance", "efficiency", "resources", "code-quality"]
	}
	"review/error-handling": {
		module:      "github.com/p3bot/library/tasks/review/error-handling@v1"
		version:     "v1.0.0"
		description: "Review how failures are handled and whether edge cases are covered"
		tags: ["review", "error-handling", "errors", "resilience", "code-quality"]
	}
	"review/observability": {
		module:      "github.com/p3bot/library/tasks/review/observability@v1"
		version:     "v1.0.0"
		description: "Assess whether the code can be understood and debugged in production"
		tags: ["review", "observability", "logging", "metrics", "code-quality"]
	}
	"review/standards": {
		module:      "github.com/p3bot/library/tasks/review/standards@v1"
		version:     "v1.0.0"
		description: "Verify changes meet applicable domain-specific standards and requirements"
		tags: ["review", "standards", "compliance", "accessibility", "code-quality"]
	}
	"review/testing": {
		module:      "github.com/p3bot/library/tasks/review/testing@v1"
		version:     "v1.0.0"
		description: "Evaluate test quality, coverage, and the testability of production code"
		tags: ["review", "testing", "tests", "coverage", "code-quality"]
	}
	"review/readability": {
		module:      "github.com/p3bot/library/tasks/review/readability@v1"
		version:     "v1.0.0"
		description: "Assess whether the code is clear and understandable to other developers"
		tags: ["review", "readability", "naming", "clarity", "code-quality"]
	}
	"review/dependency": {
		module:      "github.com/p3bot/library/tasks/review/dependency@v1"
		version:     "v1.0.0"
		description: "Review the use of third-party packages and libraries"
		tags: ["review", "dependency", "packages", "supply-chain", "code-quality"]
	}
	"review/duplication": {
		module:      "github.com/p3bot/library/tasks/review/duplication@v1"
		version:     "v1.0.0"
		description: "Identify repeated code patterns that may benefit from consolidation"
		tags: ["review", "duplication", "dry", "patterns", "code-quality"]
	}
	"review/documentation": {
		module:      "github.com/p3bot/library/tasks/review/documentation@v1"
		version:     "v1.0.0"
		description: "Review external documentation, API documentation, and developer guides"
		tags: ["review", "documentation", "api-docs", "readme", "code-quality"]
	}
	"review/css": {
		module:      "github.com/p3bot/library/tasks/review/css@v1"
		version:     "v1.0.0"
		description: "Review CSS stylesheets for consistency, maintainability, and correctness"
		tags: ["review", "css", "stylesheets", "front-end", "code-quality"]
	}
	"review/random-file": {
		module:      "github.com/p3bot/library/tasks/review/random-file@v1"
		version:     "v1.0.0"
		description: "Select a random file from the repository and perform a thorough review"
		tags: ["review", "random", "spot-check", "code-quality"]
	}
	"review/git-diff": {
		module:      "github.com/p3bot/library/tasks/review/git-diff@v1"
		version:     "v1.0.0"
		description: "Comprehensive review of code changes from git diff to catch regressions and bugs"
		tags: ["review", "diff", "regression", "code-changes", "code-quality"]
	}
	"review/test-coverage": {
		module:      "github.com/p3bot/library/tasks/review/test-coverage@v1"
		version:     "v1.0.0"
		description: "Identify test coverage gaps in the codebase and optionally create tests to fill them"
		tags: ["review", "testing", "coverage", "test-gaps", "code-quality"]
	}
	"review/pre-commit": {
		module:      "github.com/p3bot/library/tasks/review/pre-commit@v2"
		version:     "v2.0.0"
		description: "Interactive pre-commit review that finds issues in git changes and walks through fixing them"
		tags: ["review", "pre-commit", "fix", "code-changes", "code-quality"]
	}
	"review/multi-agent/orchestrator": {
		module:      "github.com/p3bot/library/tasks/review/multi-agent/orchestrator@v2"
		version:     "v2.0.0"
		description: "Orchestrate parallel review agents, consolidate findings, and walk through fixing them"
		tags: ["review", "orchestration", "multi-agent", "parallel", "fix"]
	}
	"gitlab/pipeline/review": {
		module:      "github.com/p3bot/library/tasks/gitlab/pipeline/review@v1"
		version:     "v1.0.0"
		description: "Review and investigate a GitLab pipeline or job to diagnose failures and recommend fixes"
		tags: ["gitlab", "ci-cd", "pipeline", "review", "debugging", "investigation"]
	}
	"github/issue/triage": {
		module:      "github.com/p3bot/library/tasks/github/issue/triage@v1"
		version:     "v1.0.0"
		description: "Investigate the next GitHub issue, analyse code, and assess effort"
		tags: ["github", "issue", "triage", "investigation", "planning"]
	}
	"git/conflict/resolve": {
		module:      "github.com/p3bot/library/tasks/git/conflict/resolve@v1"
		version:     "v1.0.0"
		description: "Resolve git conflicts from merge, rebase, cherry-pick, revert, stash, and patch operations"
		tags: ["git", "merge", "rebase", "conflict", "resolve"]
	}
	"git/ignore/generate": {
		module:      "github.com/p3bot/library/tasks/git/ignore/generate@v1"
		version:     "v1.0.0"
		description: "Analyse the repository and generate a precise .gitignore file"
		tags: ["git", "ignore", "gitignore", "generate"]
	}
	"start/module/author": {
		module:      "github.com/p3bot/library/tasks/start/module/author@v1"
		version:     "v1.0.0"
		description: "Create or update any agent, role, context, or task module in the library repository"
		tags: ["library", "module", "author", "create", "update", "cue", "interactive"]
	}
	"cwd/readme/create": {
		module:      "github.com/p3bot/library/tasks/cwd/readme/create@v1"
		version:     "v1.0.0"
		description: "Create a README.md for the current working directory"
		tags: ["readme", "cwd", "documentation", "markdown"]
	}
	"cwd/readme/update": {
		module:      "github.com/p3bot/library/tasks/cwd/readme/update@v1"
		version:     "v1.0.0"
		description: "Update an existing README.md for the current working directory"
		tags: ["readme", "cwd", "documentation", "markdown"]
	}
	"cwd/agents-md/create": {
		module:      "github.com/p3bot/library/tasks/cwd/agents-md/create@v1"
		version:     "v1.0.0"
		description: "Create a repository AGENTS.md file for AI coding agents"
		tags: ["agents-md", "cwd", "documentation", "markdown", "agents"]
	}
	"cwd/agents-md/update": {
		module:      "github.com/p3bot/library/tasks/cwd/agents-md/update@v1"
		version:     "v1.0.0"
		description: "Update a repository AGENTS.md file for AI coding agents"
		tags: ["agents-md", "cwd", "documentation", "markdown", "agents"]
	}
	"cwd/dotagents/role/create": {
		module:      "github.com/p3bot/library/tasks/cwd/dotagents/role/create@v1"
		version:     "v1.0.0"
		description: "Create a new system prompt (role) for AI agent use"
		tags: ["dotagents", "cwd", "role", "system-prompt", "ai"]
	}
	"ticket/create": {
		module:      "github.com/p3bot/library/tasks/ticket/create@v1"
		version:     "v1.0.0"
		description: "Create a new ticket document"
		tags: ["ticket", "create", "planning", "active", "current"]
	}
	"ticket/review": {
		module:      "github.com/p3bot/library/tasks/ticket/review@v1"
		version:     "v1.0.0"
		description: "Review and prepare the current ticket for implementation"
		tags: ["ticket", "review", "preparation", "analysis", "active", "current"]
	}
	"ticket/begin": {
		module:      "github.com/p3bot/library/tasks/ticket/begin@v1"
		version:     "v1.0.0"
		description: "Begin working on the current ticket with full context"
		tags: ["ticket", "begin", "implementation", "active", "current"]
	}
	"ticket/decompose": {
		module:      "github.com/p3bot/library/tasks/ticket/decompose@v1"
		version:     "v1.0.0"
		description: "Decompose an accepted design into a right-sized set of ticket documents"
		tags: ["ticket", "decompose", "design", "planning", "breakdown", "seams", "active", "current"]
	}
	"design/review": {
		module:      "github.com/p3bot/library/tasks/design/review@v1"
		version:     "v1.4.0"
		description: "Review and harden a design document before decomposition into ticket documents"
		tags: ["design", "review", "feature", "analysis", "architecture", "critique"]
	}
	"confluence/doc/read": {
		module:      "github.com/p3bot/library/tasks/confluence/doc/read@v1"
		version:     "v1.0.0"
		description: "Read and summarize a Confluence document"
		tags: ["confluence", "document", "read", "summary"]
	}
	"confluence/doc/tree": {
		module:      "github.com/p3bot/library/tasks/confluence/doc/tree@v1"
		version:     "v1.0.0"
		description: "Read a Confluence document and its child pages"
		tags: ["confluence", "document", "tree", "hierarchy", "read"]
	}
	"jira/item/read": {
		module:      "github.com/p3bot/library/tasks/jira/item/read@v1"
		version:     "v1.0.0"
		description: "Read and summarise a Jira work item with its status"
		tags: ["jira", "item", "read", "summary"]
	}
	"jira/item/research": {
		module:      "github.com/p3bot/library/tasks/jira/item/research@v1"
		version:     "v1.0.0"
		description: "Deep cross-system research on a Jira work item"
		tags: ["jira", "item", "research", "investigation"]
	}
	"jira/item/review": {
		module:      "github.com/p3bot/library/tasks/jira/item/review@v1"
		version:     "v1.0.0"
		description: "Comprehensive content review of a Jira work item"
		tags: ["jira", "item", "review", "quality"]
	}
	"jira/item/backlog/review": {
		module:      "github.com/p3bot/library/tasks/jira/item/backlog/review@v1"
		version:     "v1.0.0"
		description: "Review my backlog items for status accuracy"
		tags: ["jira", "item", "backlog", "review", "triage"]
	}
	"jira/item/blocked/review": {
		module:      "github.com/p3bot/library/tasks/jira/item/blocked/review@v1"
		version:     "v1.0.0"
		description: "Review my blocked items for resolution paths"
		tags: ["jira", "item", "blocked", "review", "resolution"]
	}
	"jira/item/comment/git-commit": {
		module:      "github.com/p3bot/library/tasks/jira/item/comment/git-commit@v1"
		version:     "v1.0.0"
		description: "Summarise git commits for a period and post as a human-readable Jira item comment"
		tags: ["jira", "item", "comment", "git", "commits", "summary"]
	}
	"chore/comment/prune": {
		module:      "github.com/p3bot/library/tasks/chore/comment/prune@v2"
		version:     "v2.0.0"
		description: "Prune comment bloat from source files, compressing real WHY and harvesting markers"
		tags: ["chore", "comment", "prune", "code-quality", "cleanup"]
	}
}

// Skill index - maps friendly names to module paths
skills: [string]: schemas.#IndexEntry

skills: {
	"finding/one-by-one": {
		module:      "github.com/p3bot/library/skills/finding/one-by-one@v1"
		version:     "v1.0.0"
		description: "Walk a list of findings one at a time and resolve each with a principled fix"
		tags: ["finding", "one-by-one", "workflow", "remediation", "review"]
	}
}
