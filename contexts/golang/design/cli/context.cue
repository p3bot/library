package cli

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "p3bot Go CLI guide: architecture, patterns, and conventions for command-line tools"
	tags: ["golang", "design", "cli", "go", "guide"]
	file: "@module/context.md"
	uses: ["contexts:cli/design", "contexts:golang/design/cli-skill"]
}
