package experience

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Assess whether the interface the end user or end agent consumes matches its design intent"
	tags: ["review", "experience", "interface", "accessibility", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
