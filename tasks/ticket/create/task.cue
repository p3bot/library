package create

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Create a ticket document by profile"
	tags: ["ticket", "create", "planning", "active", "current"]
	uses: ["contexts:design/writing", "contexts:ticket/writing"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
