git_changed_files() {
	git status --untracked-files=all --porcelain # TODO memoize
}

git_worktree_clean() {
	[ -z "$(git_changed_files)" ]
}

git_ref_exists() {
	git show-ref "$1" > /dev/null
}

git_branch_has_commits() {
	git rev-parse --verify HEAD >/dev/null 2>&1
}
