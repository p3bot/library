package supplychain

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review what the subject consumes and what it publishes, from dependencies through release"
	tags: ["review", "supply-chain", "dependencies", "release", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
