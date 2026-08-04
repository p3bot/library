package assistant

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "EndeavourOS Linux system administration expert - collaborative assistant mode"
	tags: ["linux", "endeavouros", "arch", "system-administration", "assistant", "collaborative"]
	file: "@module/role.md"
}
