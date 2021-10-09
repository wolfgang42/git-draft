current_head="$(git symbolic-ref HEAD)"

create_get_draft_commit_message() {
	(
		if [[ -v args[--message] ]]; then
			echo "${args[--message]}"
		fi
	) | git interpret-trailers --no-divider --if-exists replace --trailer "Draft-on:$current_head"
}

if git rev-parse HEAD &> /dev/null; then
	parent="$(git rev-parse HEAD)"
	if [[ -v args[--from-index] ]]; then
		index_tree="$(git write-tree)" # Get tree of current index
	else
		index_tree="$(git rev-parse HEAD^{tree})" # Use tree of current HEAD, with no changes from worktree/index
	fi
	draft_commit="$(git commit-tree "$index_tree" -p "$parent" -F <(create_get_draft_commit_message) </dev/null)"
else # No commits yet (orphan branch)
	empty_tree="$(git hash-object -t tree /dev/null)"
	draft_commit="$(git commit-tree "$empty_tree" -F <(create_get_draft_commit_message) </dev/null)"
fi

draft_name="$(generate_draft_name)"

git update-ref "refs/drafts/$draft_name" "$draft_commit" ''

echo "created new draft $draft_name"

if [[ -v args[--delete-from-worktree] ]]; then
	git_draft apply "$draft_name" --reverse
fi
