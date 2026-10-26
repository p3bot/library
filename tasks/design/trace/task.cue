package trace

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Check that a design's content is present in the tickets it produced"
	tags: ["design", "trace", "tickets", "coverage", "produces"]
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
