package orchestrate

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Using tk, orchestrate work across scopes"
	tags: ["tk", "scope", "orchestrate", "ticket"]
	uses: [
		"contexts:ticket/writing",
		"tasks:tk/id/continue",
	]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Scopes: {{.instructions}}
		{{else}}

		The user did not supply scope names. Ask them for the tk scope names before proceeding.
		{{end}}
		"""
}
