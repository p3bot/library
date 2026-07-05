package begin

import "github.com/start-cli/library/schemas@v1"

task: schemas.#Task & {
	description: "Begin working on the current project with full context"
	tags: ["project", "begin", "implementation", "active", "current"]
	uses: ["contexts:project/implementation"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
