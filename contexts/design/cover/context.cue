package cover

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Same-session pass that writes this conversation's decisions into the design document"
	tags: ["design", "cover", "session", "decisions", "conversation"]
	uses: ["contexts:design/writing"]
	file: "@module/context.md"
}
