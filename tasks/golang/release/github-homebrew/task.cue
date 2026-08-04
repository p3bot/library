package github_homebrew

import (
	"github.com/p3bot/library/schemas@v1"
	assistantRole "github.com/p3bot/library/roles/golang/assistant@v1:assistant"
)

task: schemas.#Task & {
	description: "Release Go project to GitHub with Homebrew tap distribution"
	tags: ["golang", "release", "github", "homebrew", "ci-cd"]
	role: assistantRole.role
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
