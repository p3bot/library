package reorder

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Using tk, fix the sequence of the board"
	tags: ["tk", "board", "reorder", "order", "depends"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
