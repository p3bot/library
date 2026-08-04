package assistant

import "github.com/p3bot/library/schemas@v1"

role: schemas.#Role & {
	description: "AI role designer and prompt engineering expert - collaborative assistant mode"
	tags: ["role", "prompt-engineering", "design", "assistant", "collaborative"]
	file: "@module/role.md"
}
