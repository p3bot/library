package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Parallel review of one ticket document, then a serial fix and one satisfaction pass"
	tags: ["hotseat", "ticket", "review"]
	uses: ["tasks:ticket/review", "contexts:ticket/writing"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
