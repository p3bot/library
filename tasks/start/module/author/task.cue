package author

import (
	"github.com/p3bot/library/schemas@v1"
	assistantRole "github.com/p3bot/library/roles/start/library/assistant@v1:assistant"
)

task: schemas.#Task & {
	description: "Create or update any agent, role, context, or task module in the library repository"
	tags: ["library", "module", "author", "create", "update", "cue", "interactive"]
	uses: [
		"contexts:start/library/naming",
		"contexts:start/library/publishing",
	]
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
