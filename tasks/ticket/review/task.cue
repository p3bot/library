package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review a ticket document against its matched profile"
	tags: ["ticket", "review", "preparation", "analysis", "active", "current"]
	uses: ["contexts:ticket/writing", "tasks:design/review", "tasks:tk/id/expand"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
