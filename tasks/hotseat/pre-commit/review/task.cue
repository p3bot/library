package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Parallel pre-commit diff review, each finding discussed and fixed by agreement, then one satisfaction pass over the fixes"
	min_members: 2
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
