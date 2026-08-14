package schemas

// Examples demonstrating skill module definitions.
// Skills are Agent Skills (SKILL.md plus optional resources), not UTD modules.

// Example 1: Minimal skill using the default entry pointer
skills: "workflows/one-by-one": #Skill & {
	description: "Walk a list of findings one at a time and resolve each with a principled fix"
	tags: ["workflow", "remediation", "review"]
}

// Example 2: Skill with an explicit file and a skills uses reference
skills: "review/pre-commit": #Skill & {
	description: "Run pre-commit checks as a skill"
	file:        "@module/SKILL.md"
	tags: ["review", "pre-commit"]
	uses: ["skills:workflows/one-by-one"]
}

// Example 3: #Base.uses accepts skills and the four existing categories
_usesExisting: #Base & {
	uses: [
		"agents:claude/interactive",
		"roles:golang/assistant",
		"contexts:cwd/agents-md",
		"tasks:review/git-diff",
		"skills:workflows/one-by-one",
	]
}
