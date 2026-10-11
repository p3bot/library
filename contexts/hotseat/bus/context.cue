package bus

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Hotseat bus commands, kind tokens, and who a message names"
	tags: ["hotseat", "bus", "conversation"]
	file: "@module/context.md"
}
