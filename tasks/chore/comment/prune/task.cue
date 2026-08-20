package prune

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Prune comment bloat from source files, compressing real WHY and harvesting markers"
	tags: ["chore", "comment", "prune", "code-quality", "cleanup"]
	uses: ["contexts:ticket/writing"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.

		The current datetime is {{.datetime}}.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
