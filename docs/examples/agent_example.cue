package schemas

// Examples demonstrating agent configurations
// Agents are command templates that launch AI CLI tools

// Example 1: Joined recipe — agentdex catalog id, no bin, CLI-alias models
agents: "claude-code/interactive": {
	agentdex:      "claude-code"
	command:       "{{.bin}} --model {{.model}} --append-system-prompt {{.role}} {{.prompt}}"
	description:   "Claude Code by Anthropic"
	default_model: "sonnet"
	models: {
		haiku:  "haiku"
		sonnet: "sonnet"
		opus:   "opus"
	}
	tags: ["anthropic", "claude", "ai"]
}

// Example 2: Gemini with file-based role
agents: "gemini": {
	bin:           "gemini"
	command:       "GEMINI_SYSTEM_MD={{.role_file}} {{.bin}} --model {{.model}} {{.prompt}}"
	description:   "Google Gemini AI"
	default_model: "pro"
	models: {
		flash: "gemini-2.0-flash"
		pro:   "gemini-2.0-pro"
	}
	tags: ["google", "gemini", "ai"]
}

// Example 3: Minimal agent - just a command
agents: "simple": {
	command: "my-ai-tool {{.prompt}}"
}

// Example 4: Custom script wrapper
agents: "custom-wrapper": {
	command:     "./scripts/ai-wrapper.sh --role {{.role}} --prompt {{.prompt}}"
	description: "Project-specific AI wrapper script"
}

// Example 5: Agent with bin but no models
agents: "aichat": {
	bin:         "aichat"
	command:     "{{.bin}} {{.prompt}}"
	description: "aichat CLI tool"
	tags: ["aichat", "cli"]
}

// Example 6: Debug/test agent - just echoes
agents: "echo": {
	command:     "echo {{.prompt}}"
	description: "Debug agent that echoes the prompt"
	tags: ["debug", "test"]
}

// Example 7: OpenAI compatible
agents: "openai": {
	bin:           "openai"
	command:       "{{.bin}} chat --model {{.model}} --system {{.role}} {{.prompt}}"
	description:   "OpenAI API CLI"
	default_model: "gpt4"
	models: {
		"gpt4":  "gpt-4-turbo"
		"gpt4o": "gpt-4o"
		"gpt35": "gpt-3.5-turbo"
	}
	tags: ["openai", "gpt", "ai"]
}

// Example 8: Local LLM via Ollama
agents: "ollama": {
	bin:           "ollama"
	command:       "{{.bin}} run {{.model}} {{.prompt}}"
	description:   "Ollama local LLM runner"
	default_model: "llama3"
	models: {
		llama3:    "llama3.2"
		mistral:   "mistral"
		codellama: "codellama"
	}
	tags: ["ollama", "local", "llm"]
}
