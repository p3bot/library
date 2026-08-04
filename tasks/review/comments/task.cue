package comments

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review code comments for accuracy, usefulness, and completeness"
	tags: ["review", "comments", "documentation", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
