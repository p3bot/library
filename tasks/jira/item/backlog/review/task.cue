package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review my backlog items for status accuracy"
	tags: ["jira", "item", "backlog", "review", "triage"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Additional instructions: {{.instructions}}
		{{end}}
		"""
}
