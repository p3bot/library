package member

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Hotseat chat member: join, speech, kinds, finding discussion, and the acting seat"
	tags: ["hotseat", "member", "chat"]
	file: "@module/role.md"
}
