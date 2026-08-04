package tree

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Read a Confluence document and its child pages"
	tags: ["confluence", "document", "tree", "hierarchy", "read"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Document ID: {{.instructions}}
		{{else}}

		The user did not supply a document ID. Ask them for the Confluence document ID before proceeding.
		{{end}}
		"""
}
