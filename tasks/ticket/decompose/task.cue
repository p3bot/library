package decompose

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Decompose an accepted design into a right-sized set of ticket documents"
	tags: ["ticket", "decompose", "design", "planning", "breakdown", "seams", "active", "current"]
	uses: ["contexts:ticket/writing"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
