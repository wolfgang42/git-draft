# TODO support amend drafts
git add -A

git_commit_args=()
if [[ -v args[--message] ]]; then
	git_commit_args+=(--message "${args[--message]}")
fi
# TODO support $(active_draft_editmsg_file)

# Set an environment variable that can be seen by git hooks, editors, etc during `git commit`,
# in case someone wants to know when a draft is being committed for some reason.
export GIT_DRAFT_COMMITTING=1

git commit "${git_commit_args[@]}"

if ! git_worktree_clean; then
	echo 'Assertion error: worktree is not clean after git-draft commit!' >&2
	echo 'This is a bug; please report it (with steps to reproduce if possible).' >&2
	exit 2
fi

if active_draft_has_name; then
	# We've successfully made the commit, so the draft can be dropped.
	git update-ref -d "$active_draft_ref" # NOTE this also deletes the destination ref
fi

if [[ -e "$(active_draft_editmsg_file)" ]]; then
	# We've successfully made the commit, so the draft's commit message can be discarded
	rm "$(active_draft_editmsg_file)"
fi

if ! active_is_empty; then
	echo 'Assertion error: active draft is not empty after git-draft commit!' >&2
	echo 'This is a bug; please report it (with steps to reproduce if possible).' >&2
	exit 2
fi
