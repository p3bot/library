package begin

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Begin working on the current ticket with full context"
	tags: ["ticket", "begin", "implementation", "active", "current"]
	uses: ["contexts:ticket/implementation"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
