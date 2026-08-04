package documentation

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review external documentation, API documentation, and developer guides"
	tags: ["review", "documentation", "api-docs", "readme", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
