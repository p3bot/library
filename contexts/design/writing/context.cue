package writing

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Session guide for designing a system or feature, then handing off to a design-profile ticket"
	tags: ["design", "writing", "feature", "architecture", "documentation", "guide", "agents", "session"]
	uses: ["contexts:ticket/writing"]
	file: "@module/context.md"
}
