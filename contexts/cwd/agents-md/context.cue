package agentsmd

import "github.com/start-cli/library/schemas@v1"

context: schemas.#Context & {
	required:    true
	default:     true
	description: "Repository introduction from AGENTS.md"
	tags: ["agents", "repository", "cwd"]
	file:    "AGENTS.md"
	command: "git remote get-url origin 2>/dev/null || echo 'No git remote'"
	prompt: """
		Repository: {{.command_output}}
		If {{.file}} is not already in your context, read it for a repository introduction.
		"""
}
