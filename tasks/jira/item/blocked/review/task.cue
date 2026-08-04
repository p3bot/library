package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review my blocked items for resolution paths"
	tags: ["jira", "item", "blocked", "review", "resolution"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Additional instructions: {{.instructions}}
		{{end}}
		"""
}
