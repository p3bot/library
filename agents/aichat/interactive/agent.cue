package interactive

import "github.com/p3bot/library/schemas@v1"

agent: schemas.#Agent & {
	bin:         "aichat"
	command:     "{{.bin}} --model {{.model}} --prompt {{.role}} {{.prompt}}"
	description: "AIChat - All-in-one LLM CLI tool by sigoden"
	default_model: "vertexai:gemini-2.5-flash"
	models: {
		flash:        "vertexai:gemini-2.5-flash"
		"flash-lite": "vertexai:gemini-2.5-flash-lite"
		pro:          "vertexai:gemini-2.5-pro"
	}
	tags: ["aichat", "multi-provider", "rag", "agents"]
}
