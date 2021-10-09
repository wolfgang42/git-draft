if ! active_is_empty; then
	git_draft stash-active
fi

git_draft activate-stashed "${args[draft-name]}"
