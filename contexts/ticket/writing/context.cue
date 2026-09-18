package writing

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Guide for writing ticket documents by profile as the sole context for a fresh-session agent"
	tags: ["ticket", "writing", "documentation", "guide", "agents", "profile"]
	file: "@module/context.md"
}
