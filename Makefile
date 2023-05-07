.RECIPEPREFIX = >


jobs.json:
> ./scripts/get-himalayas-jobs.sh jobs.json

.PHONY: gh_run
gh_run:
> gh workflow run gather-himalayas-job.yaml
