package triage

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Parallel triage of one ticket: pass, stub, reject, or split"
	tags: ["hotseat", "ticket", "triage"]
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
