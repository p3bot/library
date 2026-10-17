package chief

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Ongoing hotseat chief: one bus, many conversations, roster and repair"
	tags: ["hotseat", "chief", "conversation"]
	file: "@module/role.md"
}
