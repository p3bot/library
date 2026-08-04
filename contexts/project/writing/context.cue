package writing

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Guide for writing project documents that serve as the sole context for an implementer agent"
	tags: ["project", "writing", "documentation", "guide", "agents"]
	file: "@module/context.md"
}
