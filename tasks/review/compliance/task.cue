package compliance

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Verify the subject meets legal, regulatory, and organisational policy obligations"
	tags: ["review", "compliance", "privacy", "policy", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
