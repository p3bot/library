package security

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Identify vulnerabilities, security weaknesses, and potential attack vectors"
	tags: ["review", "security", "vulnerabilities", "attack-vectors", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
