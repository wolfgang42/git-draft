#: name: stash
#: help: "Makes the current active draft into a stashed draft (leaving behind an empty active draft)"

stash_get_draft_commit_message() {
	git_draft get-commit-message --for-draft=active
}

# Index everything and get tree of it
if git_worktree_clean; then
	had_changes=0
else
	had_changes=1
	git add -A
fi
index_tree="$(git write-tree)"

# Create a commit
if git_branch_has_commits; then
	parent="$(git rev-parse HEAD)"
	draft_commit="$(git commit-tree "$index_tree" -p "$parent" -F <(stash_get_draft_commit_message) </dev/null)"
else # No commits yet (orphan branch)
	draft_commit="$(git commit-tree "$index_tree" -F <(stash_get_draft_commit_message) </dev/null)"
fi

# Annotate commit
git notes --ref=drafts-info add -F <(git_draft get-trailers active | git interpret-trailers --no-divider --if-exists=replace --trim-empty --trailer "Draft-ref:") "$draft_commit"

# Update refs as appropriate
if active_draft_has_name; then
	draft_ref="$(active_draft_ref)"
	git update-ref "$draft_ref" "$draft_commit" ''
	echo "stashed draft $draft_ref" # TODO use name instead of ref
else
	draft_name="$(generate_draft_name)"
	git update-ref "refs/drafts/$draft_name" "$draft_commit" ''
	echo "created new draft $draft_name"
fi

if [[ "$had_changes" == 1 ]]; then
	# Clean worktree of changes now that they're in the draft commit
	git show --patch "$draft_commit" | git apply --index --reverse
	if [[ -e "$(active_draft_editmsg_file)" ]]; then
		rm "$(active_draft_editmsg_file)"
	fi
	if [[ -e "$(active_draft_notes_file)" ]]; then
		rm "$(active_draft_notes_file)"
	fi
fi

if ! active_is_empty; then
	echo 'Assertion error: active draft is not empty after git-draft stash!' >&2
	echo 'This is a bug; please report it (with steps to reproduce if possible).' >&2
	exit 2
fi
