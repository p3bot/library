package gitdiff

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Comprehensive review of code changes from git diff to catch regressions and bugs"
	tags: ["review", "diff", "regression", "code-changes", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
