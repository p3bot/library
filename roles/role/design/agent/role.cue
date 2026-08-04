package agent

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "AI role designer and prompt engineering expert - autonomous agent mode"
	tags: ["role", "prompt-engineering", "design", "agent", "autonomous"]
	file: "@module/role.md"
}
