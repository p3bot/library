package dependency

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review the use of third-party packages and libraries"
	tags: ["review", "dependency", "packages", "supply-chain", "license"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
