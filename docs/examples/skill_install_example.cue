package schemas

// Examples of start skills.cue inventory entries.
// Keys are group/name library addresses. Each value is origin and version only.
// This is not the library #Skill module type.

skills: {
	"finding/one-by-one": #SkillInstall & {
		origin:  "github.com/p3bot/library/skills/finding/one-by-one@v1"
		version: "v1.0.0"
	}
	"review/pre-commit": #SkillInstall & {
		origin:  "github.com/p3bot/library/skills/review/pre-commit@v1"
		version: "v1.0.0"
	}
}
