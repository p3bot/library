package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Comprehensive content review of a Jira work item"
	tags: ["jira", "item", "review", "quality"]
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
