module: "github.com/p3bot/library/tasks/gitlab/pipeline/review@v1"
language: {
	version: "v0.16.0"
}
source: {
	kind: "git"
}
deps: {
	"github.com/p3bot/library/roles/gitlab/pipeline/agent@v1": {
		v: "v1.0.0"
	}
	"github.com/p3bot/library/schemas@v1": {
		v: "v1.0.0"
	}
}
