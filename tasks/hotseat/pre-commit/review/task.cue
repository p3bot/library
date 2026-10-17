package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Parallel pre-commit diff review, a serial fix, and one satisfaction pass"
	tags: ["hotseat", "pre-commit", "review"]
	uses: ["tasks:review/pre-commit"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
