package observability

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Assess whether the code can be understood and debugged in production"
	tags: ["review", "observability", "logging", "metrics", "tracing"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
