package continue

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Using tk, continue this ticket"
	tags: ["tk", "id", "continue", "implementation", "ticket"]
	uses: ["contexts:ticket/implementation"]
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
