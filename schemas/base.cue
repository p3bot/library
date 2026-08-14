package schemas

// #Base defines common fields for all module types.
// Embedded by #Agent, #Role, #Task, #Context, and #Skill.
#Base: {
	// Human-readable description of the module
	description?: string

	// Tags for categorization and filtering
	// Must be lowercase kebab-case
	tags?: [...string & =~"^[a-z0-9]+(-[a-z0-9]+)*$"]

	// Module path when installed from registry
	// Example: "github.com/p3bot/library/tasks/review/git-diff@v0"
	// Empty/undefined = user-defined module
	origin?: string

	// Other library modules this module pulls in at runtime via `start get`.
	// Fully-qualified colon-form addresses only: "<category>:<path>" where
	// category is one of agents, roles, contexts, tasks, skills. Bare names
	// and unknown categories are rejected.
	uses?: [...string & =~"^(agents|roles|contexts|tasks|skills):[a-z0-9]+(-[a-z0-9]+)*(/[a-z0-9]+(-[a-z0-9]+)*)*$"]
}
