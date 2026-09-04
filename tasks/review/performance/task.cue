package performance

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Analyse the subject's efficiency and resource usage"
	tags: ["review", "performance", "efficiency", "resources", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
