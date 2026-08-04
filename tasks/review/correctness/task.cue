package correctness

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Verify code logic correctly implements intended behaviour and handles data with precision"
	tags: ["review", "correctness", "logic", "behaviour", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
