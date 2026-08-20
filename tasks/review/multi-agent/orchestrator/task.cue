package orchestrator

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Orchestrate parallel review agents, consolidate findings, and walk through fixing them"
	tags: ["review", "orchestration", "multi-agent", "parallel", "fix"]
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
