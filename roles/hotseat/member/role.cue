package member

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Hotseat conversation member: speech, kinds, finding discussion, and the acting seat"
	tags: ["hotseat", "member", "conversation"]
	file: "@module/role.md"
}
