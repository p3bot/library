package precommit

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Interactive pre-commit review that finds issues in git changes and walks through fixing them"
	tags: ["review", "pre-commit", "fix", "code-changes", "code-quality"]
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
