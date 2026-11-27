package chief

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Ongoing hotseat chief: one bus, many chats, run new and continue, roster and repair"
	tags: ["hotseat", "chief", "chat"]
	file: "@module/role.md"
}
