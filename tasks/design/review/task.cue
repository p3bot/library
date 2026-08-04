package review

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Review and harden a design document before it becomes project documents"
	tags: ["design", "review", "feature", "analysis", "architecture", "critique"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
