package begin

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Begin working the matched profile of the current ticket"
	tags: ["ticket", "begin", "implementation", "active", "current"]
	uses: ["contexts:ticket/implementation"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
