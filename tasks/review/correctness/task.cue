package correctness

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Verify the subject implements intended behaviour precisely, including under concurrency"
	tags: ["review", "correctness", "logic", "behaviour", "concurrency", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
