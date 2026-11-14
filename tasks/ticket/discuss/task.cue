package discuss

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Brief a ticket against its matched profile, then discuss it"
	tags: ["ticket", "discuss", "brief", "tk"]
	uses: ["contexts:ticket/writing", "tasks:ticket/expand", "tasks:design/discuss"]
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
