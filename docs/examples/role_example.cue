package schemas

// Examples demonstrating role definitions
// Roles define AI agent behavior via system prompts using the UTD pattern

// User applies global defaults via pattern constraint
roles: [_]: #Role & {
	timeout: *60 | _          // Global default: 60 seconds
	shell:   *"/bin/bash" | _ // Global default shell
}

// Example 1: Simple file-based role
// The file contains the complete system prompt
roles: "general-assistant": {
	description: "General purpose AI assistant"
	file:        "~/.config/start/roles/general.md"
	tags: ["general", "assistant"]
}

// Example 2: Inline prompt role
// System prompt defined directly in config
roles: "documentation-writer": {
	description: "Technical documentation specialist"
	prompt: """
		You are a technical documentation specialist.

		Guidelines:
		- Use clear, concise language
		- Include code examples where helpful
		- Focus on user needs
		- Use active voice and present tense
		"""
	tags: ["documentation", "writing"]
}

// Example 3: File with template framing
// Base file enhanced with additional instructions
roles: "code-reviewer": {
	description: "Code reviewer with additional context"
	file:        "~/.config/start/roles/reviewer.md"
	prompt: """
		{{.file_contents}}

		Additional Instructions:
		- Focus on security and performance
		- Check for edge cases
		- Verify error handling
		"""
	tags: ["review", "code", "quality"]
}

// Example 4: Dynamic role with environment context
// Command injects runtime information into the role
roles: "go-expert": {
	description: "Go language expert with environment awareness"
	file:        "~/.config/start/roles/go-base.md"
	command:     "go version 2>/dev/null || echo 'Go not installed'"
	prompt: """
		{{.file_contents}}

		Environment: {{.command_output}}

		Apply Go-specific best practices and idioms.
		"""
	tags: ["golang", "programming", "expert"]
}

// Example 5: Project-aware role
// Reads project context at runtime
roles: "project-contributor": {
	description: "Project-specific contributor with context"
	file:        "./AGENTS.md"
	command:     "git remote get-url origin 2>/dev/null || echo 'No git remote'"
	prompt: """
		Project Context:
		{{.file_contents}}

		Repository: {{.command_output}}

		You are a contributor to this project. Follow its conventions.
		"""
	tags: ["project", "contributor"]
}

// Example 6: Security-focused role
// Specialized role with strict guidelines
roles: "security-auditor": {
	description: "Security-focused code auditor"
	prompt: """
		You are a security auditor specializing in code review.

		Your focus areas:
		- OWASP Top 10 vulnerabilities
		- Input validation and sanitization
		- Authentication and authorization flaws
		- Cryptographic weaknesses
		- Injection vulnerabilities (SQL, command, XSS)

		Always err on the side of caution. Flag potential issues
		even if exploitation seems unlikely.
		"""
	tags: ["security", "audit", "review"]
}

// Example 7: Shell override for Python-based role generation
roles: "data-scientist": {
	description: "Data science expert with Python environment context"
	shell:       "python3"
	command:     "import sys; print(f'Python {sys.version}')"
	prompt: """
		You are a data science expert.

		Environment: {{.command_output}}

		Focus on:
		- Statistical analysis
		- Machine learning best practices
		- Data visualization
		- Reproducible research
		"""
	tags: ["data-science", "python", "ml"]
}

// Example 8: Automatically selected role
// Used when no role is named and ./ROLE.md exists; lower priority is tried first
roles: "project-role": {
	description: "Project role from ROLE.md"
	file:        "./ROLE.md"
	priority:    15
	tags: ["project", "default"]
}
