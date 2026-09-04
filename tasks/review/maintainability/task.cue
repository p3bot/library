package maintainability

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Assess whether the subject can be read, navigated, documented, and changed safely"
	tags: ["review", "maintainability", "clarity", "documentation", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
