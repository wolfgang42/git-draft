git_changed_files() {
	git status --untracked-files=all --porcelain # TODO memoize
}

git_worktree_clean() {
	[ -s "$(git_changed_files)" ]
}

git_ref_exists() {
	git show-ref "$1" > /dev/null
}
