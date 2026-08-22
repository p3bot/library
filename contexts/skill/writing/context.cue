package writing

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Guide for writing agent-facing SKILL.md files that are token-efficient without losing functionality"
	tags: ["skill", "writing", "documentation", "guide", "agents"]
	file: "@module/context.md"
}
