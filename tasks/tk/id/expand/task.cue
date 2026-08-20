package expand

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Using tk, expand this ticket to the writing guide"
	tags: ["tk", "id", "expand", "ticket", "writing", "stub"]
	uses: ["contexts:ticket/writing"]
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
