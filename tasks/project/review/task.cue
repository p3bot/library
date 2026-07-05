package review

import "github.com/start-cli/library/schemas@v1"

task: schemas.#Task & {
	description: "Review and prepare the current project for implementation"
	tags: ["project", "review", "preparation", "analysis", "active", "current"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
