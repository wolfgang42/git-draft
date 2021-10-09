if git show-ref refs/git-draft/active > /dev/null; then
	echo n # Active draft has name
elif ! git_worktree_clean; then
	echo 'n' # Workdir is not clean
elif [ -s "$(active_draft_editmsg_file)" ]; then
	echo 'n' # Message is not empty
else
	echo 'y'
fi
