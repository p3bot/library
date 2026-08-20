package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review and prepare the current ticket for implementation"
	tags: ["ticket", "review", "preparation", "analysis", "active", "current"]
	uses: ["contexts:ticket/writing"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
