package assistant

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Go programming language expert - collaborative assistant mode"
	tags: ["golang", "programming", "assistant", "collaborative"]
	file: "@module/role.md"
}
