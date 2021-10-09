current_head="$(git symbolic-ref HEAD)"

stash_get_draft_commit_message_raw() {
	if [[ -e "$(active_draft_editmsg_file)" ]]; then
		cat "$(active_draft_editmsg_file)"
		rm "$(active_draft_editmsg_file)"
	fi
}

stash_get_draft_commit_message() {
	stash_get_draft_commit_message_raw | git interpret-trailers --no-divider --if-exists replace --trailer "Draft-on:$current_head"
}

# Index everything and get tree of it
git add -A
index_tree="$(git write-tree)"

# Create a commit
if git rev-parse HEAD &> /dev/null; then
	parent="$(git rev-parse HEAD)"
	draft_commit="$(git commit-tree "$index_tree" -p "$parent" -F <(stash_get_draft_commit_message) </dev/null)"
else # No commits yet (orphan branch)
	draft_commit="$(git commit-tree "$index_tree" -F <(stash_get_draft_commit_message) </dev/null)"
fi

# Update refs as appropriate
if active_draft_has_name; then
	draft_ref="$(active_draft_ref)"
	git update-ref "$draft_ref" "$draft_commit"
	git symbolic-ref --delete "$active_draft_ref"
	echo "stashed draft $draft_ref" # TODO use name instead of ref
else
	draft_name="$(generate_draft_name)"
	git update-ref "refs/drafts/$draft_name" "$draft_commit" ''
	echo "created new draft $draft_name"
fi

# Clean worktree of changes now that they're in the draft commit
git show "$draft_commit" | git apply --index --reverse

if ! active_is_empty; then
	echo 'Assertion error: active draft is not empty after git-draft stash-active!' >&2
	echo 'This is a bug; please report it (with steps to reproduce if possible).' >&2
	exit 2
fi
