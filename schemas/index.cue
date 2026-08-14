package schemas

// #IndexEntry defines metadata for discovering and installing modules from the registry.
// The index maps friendly names to module paths, enabling CLI search and discovery.
#IndexEntry: {
	// module is the full OCI module path
	module: string & =~"^[a-z0-9.-]+/[a-z0-9/_-]+@v[0-9]+$"

	// description for search and display
	description?: string

	// tags for categorization and search
	tags?: [...string]

	// version is the latest published version (required for update detection)
	version: string & =~"^v[0-9]+\\.[0-9]+\\.[0-9]+$"

	// bin is the executable name for PATH detection (agents only)
	// Used by auto-setup to detect installed AI CLI tools
	bin?: string & !=""
}

// #Index defines the structure for the module discovery index.
// This enables CLI search without requiring access to OCI catalog API.
//
// Keys use category/name format (e.g., "golang/code-review", "git/pre-commit").
// Keys are bare names within their category struct; the colon prefix used in
// fully-qualified user-facing addresses (e.g., "tasks:golang/code-review")
// is supplied by the category struct itself, not the key.
// Keys map directly to the directory structure and module naming.
#Index: {
	// agents maps "category/name" to module info
	// Examples: "claude/interactive", "gemini/interactive"
	agents?: [string]: #IndexEntry

	// roles maps "category/name" to module info
	// Examples: "golang/assistant", "review/code-reviewer"
	roles?: [string]: #IndexEntry

	// contexts maps "category/name" to module info
	// Examples: "cwd/agents-md", "cwd/dotagents/workspace"
	contexts?: [string]: #IndexEntry

	// tasks maps "category/name" to module info
	// Examples: "review/git-diff", "git/pre-commit"
	tasks?: [string]: #IndexEntry

	// skills maps "group/name" to module info
	// Examples: "workflows/one-by-one"
	skills?: [string]: #IndexEntry
}
