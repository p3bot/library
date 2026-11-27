package bus

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Hotseat chat commands, exit status, kind tokens, finding discussion rules, and who a message names"
	tags: ["hotseat", "bus", "chat"]
	file: "@module/context.md"
}
