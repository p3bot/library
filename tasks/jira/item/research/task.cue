package research

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Deep cross-system research on a Jira work item"
	tags: ["jira", "item", "research", "investigation"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Item ID: {{.instructions}}
		{{else}}

		The user did not supply an item ID. Ask them for the Jira work item ID before proceeding.
		{{end}}
		"""
}
