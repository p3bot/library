package implementation

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Guide for working a ticket document by profile as the sole context for the work"
	tags: ["ticket", "implementation", "implement", "implementing", "execution", "delivery", "documentation", "guide", "agents"]
	uses: ["contexts:ticket/writing", "contexts:design/writing"]
	file: "@module/context.md"
}
