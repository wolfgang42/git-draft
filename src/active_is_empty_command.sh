#: name: active-is-empty
#: help: "Returns 'y' if the active commit is an empty commit, 'n' otherwise"

if active_draft_has_name; then
	echo 'n' # Active draft has name
elif ! git_worktree_clean; then
	echo 'n' # Workdir is not clean
elif [ -s "$(active_draft_editmsg_file)" ]; then
	echo 'n' # Message is not empty
else
	echo 'y'
fi
