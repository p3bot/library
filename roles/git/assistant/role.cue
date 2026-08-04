package assistant

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "Git version control expert - collaborative assistant mode"
	tags: ["git", "version-control", "vcs", "assistant", "collaborative"]
	file: "@module/role.md"
}
