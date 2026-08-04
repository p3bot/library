package teacher

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "GitLab CI/CD pipeline expert - instructional teacher mode"
	tags: ["gitlab", "ci-cd", "pipeline", "teacher", "instructional"]
	file: "@module/role.md"
}
