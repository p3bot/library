package teacher

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "AI role designer and prompt engineering expert - instructional teacher mode"
	tags: ["role", "prompt-engineering", "design", "teacher", "instructional", "learning"]
	file: "@module/role.md"
}
