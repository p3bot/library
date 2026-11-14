package expand

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Expand a ticket to a matching writing-guide profile"
	tags: ["ticket", "expand", "writing", "stub", "tk"]
	uses: ["contexts:design/writing", "contexts:ticket/writing"]
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
