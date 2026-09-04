package operability

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Assess whether the subject can be run, observed, kept serving, and recovered in production"
	tags: ["review", "operability", "reliability", "observability", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
