package duplication

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Identify repeated code patterns that may benefit from consolidation"
	tags: ["review", "duplication", "dry", "patterns", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
