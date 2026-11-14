package continue

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Continue a ticket by its matched profile, reopening it in tk"
	tags: ["ticket", "continue", "implementation", "tk", "reopen"]
	uses: ["contexts:ticket/implementation", "contexts:design/writing"]
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
