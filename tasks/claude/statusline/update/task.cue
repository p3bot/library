package update

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Interactively customise the Claude Code statusline script"
	tags: ["claude", "statusline", "customise", "interactive", "settings"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
