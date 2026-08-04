package teacher

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Go programming language expert - instructional teacher mode"
	tags: ["golang", "programming", "teacher", "instructional", "learning"]
	file: "@module/role.md"
}
