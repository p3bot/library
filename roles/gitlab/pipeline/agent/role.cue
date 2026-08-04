package agent

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "GitLab CI/CD pipeline expert - autonomous agent mode"
	tags: ["gitlab", "ci-cd", "pipeline", "agent", "autonomous"]
	file: "@module/role.md"
}
