package interactive

import "github.com/start-cli/library/schemas@v1"

agent: schemas.#Agent & {
	bin:           "agy"
	command:       "{{.bin}} --model {{.model}} --prompt-interactive {{.prompt}}"
	description:   "Antigravity CLI by Google - agentic coding assistant"
	default_model: "flash"
	models: {
		flash:            "Gemini 3.5 Flash (Medium)"
		"flash-high":     "Gemini 3.5 Flash (High)"
		"flash-low":      "Gemini 3.5 Flash (Low)"
		pro:              "Gemini 3.1 Pro (High)"
		"pro-low":        "Gemini 3.1 Pro (Low)"
		"gemini-3-flash": "Gemini 3 Flash"
	}
	tags: ["google", "agy", "antigravity", "coding", "agent"]
}
