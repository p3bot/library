package design

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "p3bot guide to agent-first CLIs: designing and auditing command-line tools"
	tags: ["cli", "design", "agents", "guide"]
	file: "@module/context.md"
	uses: ["contexts:skill/writing"]
}
