package publishing

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Canonical workflow for publishing library modules to the CUE Central Registry"
	tags: ["start", "library", "publishing", "publish", "release", "registry", "workflow", "guide"]
	file: "@module/context.md"
}
