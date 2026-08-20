package satisfactioncheck

import "github.com/p3bot/library/schemas@v1"

skill: schemas.#Skill & {
	description: "Critical fresh-eyes self-review of the work just produced, surfacing what is wrong rather than reassuring"
	tags: ["finding", "satisfaction-check", "review", "critic", "sat"]
}
