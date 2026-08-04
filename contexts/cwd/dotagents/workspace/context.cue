package workspace

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	required:    true
	default:     true
	description: "Workspace context from .agents/workspace.md"
	tags: ["dotagents", "cwd", "workspace"]
	file:   ".agents/workspace.md"
	prompt: "Read the {{.file}} file for workspace context."
}
