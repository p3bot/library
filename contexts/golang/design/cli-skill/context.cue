package cliskill

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "p3bot Go CLI guide: implementing an embedded agent skill with install, list, and uninstall"
	tags: ["golang", "design", "cli-skill", "cli", "go", "skill", "guide"]
	file: "@module/context.md"
	uses: ["contexts:cli/design", "contexts:golang/design/cli", "contexts:skill/writing"]
}
