package generate

import (
	"github.com/p3bot/library/schemas@v1"
	assistantRole "github.com/p3bot/library/roles/git/assistant@v1:assistant"
)

task: schemas.#Task & {
	description: "Analyse the repository and generate a precise .gitignore file"
	tags: ["git", "ignore", "gitignore", "generate"]
	role: assistantRole.role
	file: "@module/task.md"
	prompt: """
		{{.file_contents}}
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
