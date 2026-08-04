package assistant

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "GitLab CI/CD pipeline expert - collaborative assistant mode"
	tags: ["gitlab", "ci-cd", "pipeline", "assistant", "collaborative"]
	file: "@module/role.md"
}
