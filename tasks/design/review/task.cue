package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review a design-profile ticket before decompose"
	tags: ["design", "review", "feature", "analysis", "architecture", "critique"]
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
