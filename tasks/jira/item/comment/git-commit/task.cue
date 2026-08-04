package gitcommit

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Summarise git commits for a period and post as a human-readable Jira item comment"
	tags: ["jira", "item", "comment", "git", "commits", "summary"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Instructions: {{.instructions}}
		{{else}}

		No instructions were supplied. Follow the task defaults.
		{{end}}
		"""
}
