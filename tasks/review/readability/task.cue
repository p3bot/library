package readability

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Assess whether the code is clear and understandable to other developers"
	tags: ["review", "readability", "naming", "clarity", "complexity"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
