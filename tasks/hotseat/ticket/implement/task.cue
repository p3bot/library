package implement

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Single-seat implementation of one ticket, closed at review status"
	tags: ["hotseat", "ticket", "implement"]
	uses: ["contexts:ticket/implementation", "contexts:ticket/writing"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
