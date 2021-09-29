git_changed_files() {
	git status --untracked-files=all --porcelain # TODO memoize
}

git_worktree_clean() {
	[ -s "$(git_changed_files)" ]
}
