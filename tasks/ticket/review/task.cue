package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review a ticket document against its matched profile"
	tags: ["ticket", "review", "preparation", "analysis", "tk", "active", "current"]
	uses: ["contexts:ticket/writing", "tasks:ticket/expand", "tasks:design/review", "tasks:design/decompose"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Ticket: {{.instructions}}
		{{else}}

		The user did not name a ticket. Ask them for the ticket id or path before proceeding.
		{{end}}
		"""
}
