git_dir() {
	git rev-parse --git-dir # TODO memoize
}

active_draft_editmsg_file() {
	echo "$(git_dir)/GITDRAFT_COMMIT_EDITMSG"
}

active_draft_notes_file() {
	echo "$(git_dir)/GITDRAFT_NOTES"
}
