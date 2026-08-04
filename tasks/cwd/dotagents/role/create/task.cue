package create

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Create a new system prompt (role) for AI agent use"
	tags: ["dotagents", "cwd", "role", "system-prompt", "ai"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
