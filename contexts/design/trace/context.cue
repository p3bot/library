package trace

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Check that a design's content is present in the tickets it produced"
	tags: ["design", "trace", "tickets", "coverage", "produces"]
	uses: ["contexts:ticket/writing"]
	file: "@module/context.md"
}
