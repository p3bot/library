package teacher

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Git version control expert - instructional teacher mode"
	tags: ["git", "version-control", "vcs", "teacher", "instructional", "learning"]
	file: "@module/role.md"
}
