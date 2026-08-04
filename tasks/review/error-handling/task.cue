package errorhandling

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review how failures are handled and whether edge cases are covered"
	tags: ["review", "error-handling", "errors", "resilience", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
