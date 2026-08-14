package onebyone

import "github.com/p3bot/library/schemas@v1"

skill: schemas.#Skill & {
	description: "Walk a list of findings one at a time and resolve each with a principled fix"
	tags: ["workflow", "remediation", "review"]
}
