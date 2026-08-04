package create

import (
	"github.com/p3bot/library/schemas@v1"
	agentRole "github.com/p3bot/library/roles/markdown/low-token/agent@v1:agent"
)

task: schemas.#Task & {
	description: "Create a repository AGENTS.md file for AI coding agents"
	tags: ["agents-md", "cwd", "documentation", "markdown", "agents"]
	role: agentRole.role
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
