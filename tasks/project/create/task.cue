package create

import "github.com/start-cli/library/schemas@v1"

task: schemas.#Task & {
	description: "Create a new project document"
	tags: ["project", "create", "planning", "active", "current"]
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
