package groom

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Using tk, groom the board"
	tags: ["tk", "board", "groom", "status", "hygiene"]
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
