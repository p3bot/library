package workflow

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Feature development workflow for Documentation Driven Development"
	tags: ["dotagents", "home", "workflow", "development"]
	file:   "~/.agents/workflow.md"
	prompt: "Read the {{.file}} file to understand the feature development workflow."
}
