package concurrency

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Identify threading, parallelism, and asynchronous execution issues"
	tags: ["review", "concurrency", "threading", "parallelism", "code-quality"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		## Custom Instructions

		{{.instructions}}
		{{end}}
		"""
}
