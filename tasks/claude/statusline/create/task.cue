package create

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Install the Claude Code statusline script and wire it into settings.json"
	tags: ["claude", "statusline", "configuration", "settings", "shell"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
