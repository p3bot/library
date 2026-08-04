package holistic

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Broad first-pass review assessing overall repository health, consistency, and structure"
	tags: ["review", "holistic", "code-quality", "repository", "comprehensive"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
