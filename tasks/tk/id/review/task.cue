package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Using tk, review this ticket document"
	tags: ["tk", "id", "review", "ticket", "document"]
	uses: ["tasks:ticket/review"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Ticket ID: {{.instructions}}
		{{else}}

		The user did not supply a ticket ID. Ask them for the ticket ID before proceeding.
		{{end}}
		"""
}
