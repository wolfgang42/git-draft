# TODO support amend drafts
git add -A

git_commit_args=()
if [[ -v args[--message] ]]; then
	git_commit_args+=(--message "${args[--message]}")
fi
# TODO support $(active_draft_editmsg_file)
git commit "${git_commit_args[@]}"
