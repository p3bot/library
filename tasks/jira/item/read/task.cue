package read

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Read and summarise a Jira work item with its status"
	tags: ["jira", "item", "read", "summary"]
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
