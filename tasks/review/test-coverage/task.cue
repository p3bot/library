package testcoverage

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Identify test coverage gaps in the codebase and optionally create tests to fill them"
	tags: ["review", "testing", "coverage", "test-gaps", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
