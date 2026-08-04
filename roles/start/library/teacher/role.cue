package teacher

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "library expert - educational teacher mode"
	tags: ["library", "cue", "teacher", "educational"]
	file: "@module/role.md"
}
