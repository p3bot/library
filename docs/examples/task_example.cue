package schemas

// Example: How tasks would be defined in user config
// This demonstrates applying global defaults to all tasks

// User applies global defaults via pattern constraint
tasks: [_]: #Task & {
	timeout: *120 | _         // Global default: 120 seconds
	shell:   *"/bin/bash" | _ // Global default shell
}

// User defines concrete tasks (the map key is the task name)
tasks: {
	"code-review": {
		description: "Review code changes before committing"
		role:        "code-reviewer"
		agent:       "claude"
		command:     "git diff --staged"
		prompt: """
			Review these code changes:

			{{.command_output}}

			Special focus: {{.instructions}}

			Check for:
			- Code quality
			- Security issues
			- Best practices
			"""
		timeout: 30 // Override global default
		tags: ["review", "git", "quality"]
	}

	"golang-lint": {
		description: "Run Go linter on codebase"
		command:     "golangci-lint run"
		prompt: """
			Linter results:

			{{.command_output}}

			Suggest fixes for: {{.instructions}}
			"""
		tags: ["golang", "lint"]
		// timeout: 120 from global default
	}

	"doc-review": {
		description: "Review documentation file"
		file:        "./README.md"
		prompt: """
			Review this documentation:

			{{.file_contents}}

			Focus on: {{.instructions}}
			"""
		tags: ["documentation", "review"]
		// timeout: 120 from global default
	}

	"pair-review": {
		description: "Review a change with two or more agents"
		prompt:      "Review {{.instructions}} and discuss each finding"
		min_members: 2 // A roster smaller than 2 cannot run this task
		tags: ["review"]
	}

	// This will FAIL validation - no file, command, or prompt
	// "invalid-task": {
	//     description: "This is invalid"
	//     role: "test"
	// }
}
