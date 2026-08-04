package index

import "github.com/p3bot/library/schemas@v1"

context: schemas.#Context & {
	description: "Index of curated reference material in .agents/context/"
	tags: ["dotagents", "cwd", "context", "index", "reference"]
	command: "cat .agents/context/*/index.csv 2>/dev/null | sort -u || echo 'No context index found'"
	prompt:  "Project reference material index from .agents/context/:\n{{.command_output}}"
}
