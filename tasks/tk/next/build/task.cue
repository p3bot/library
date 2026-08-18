package build

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Using tk, build the next available ticket"
	tags: ["tk", "next", "build", "implementation", "ticket"]
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
