package decompose

import "github.com/start-cli/library/schemas@v1"

task: schemas.#Task & {
	description: "Decompose an accepted design into a right-sized set of project documents"
	tags: ["project", "decompose", "design", "planning", "breakdown", "seams", "active", "current"]
	uses: ["contexts:project/writing"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
