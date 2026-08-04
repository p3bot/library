package review

import (
	"github.com/p3bot/library/schemas@v1"
	agentRole "github.com/p3bot/library/roles/gitlab/pipeline/agent@v1:agent"
)

task: schemas.#Task & {
	description: "Review and investigate a GitLab pipeline or job to diagnose failures and recommend fixes"
	tags: ["gitlab", "ci-cd", "pipeline", "review", "debugging", "investigation"]
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
