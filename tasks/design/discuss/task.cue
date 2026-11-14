package discuss

import "github.com/p3bot/library/schemas@v1"

task: schemas.#Task & {
	description: "Brief a design document against the design writing guide, then discuss it"
	tags: ["design", "discuss", "brief", "architecture", "tk"]
	uses: ["contexts:design/writing", "contexts:design/cover", "tasks:design/review", "tasks:design/decompose"]
	file: "@module/task.md"
	prompt: """
		Read {{.file}} to understand your task.
		{{if .instructions}}

		Design: {{.instructions}}
		{{else}}

		The user did not name a design. Ask them for the design id or path before proceeding.
		{{end}}
		"""
}
