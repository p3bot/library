package writing

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Session guide and document contract for designing a system or feature"
	tags: ["design", "writing", "feature", "architecture", "documentation", "guide", "agents", "session"]
	file: "@module/context.md"
}
