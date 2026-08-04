package architecture

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Evaluate system structure, design decisions, and component organisation"
	tags: ["review", "architecture", "design", "structure", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
