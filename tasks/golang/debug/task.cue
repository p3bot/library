package debug

import (
	"github.com/p3bot/library/schemas@v1"
	agentRole "github.com/p3bot/library/roles/golang/agent@v1:agent"
)

task: schemas.#Task & {
	description: "Systematically debug and resolve issues in Go code"
	tags: ["golang", "debug", "troubleshooting", "bugs", "investigation"]
	role: agentRole.role
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
