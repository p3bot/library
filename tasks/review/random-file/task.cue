package randomfile

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Select a random file from the repository and perform a thorough review"
	tags: ["review", "random", "spot-check", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
