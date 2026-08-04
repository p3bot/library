package agent

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Low-token markdown expert - autonomous agent mode"
	tags: ["markdown", "low-token", "commonmark", "agent", "autonomous"]
	file: "@module/role.md"
}
