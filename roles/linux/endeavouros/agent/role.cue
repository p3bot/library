package agent

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "EndeavourOS Linux system administration expert - autonomous agent mode"
	tags: ["linux", "endeavouros", "arch", "system-administration", "agent", "autonomous"]
	file: "@module/role.md"
}
