#: name: create
#: help: Create a new stashed draft
#: 
#: flags:
#: - long: --message
#:   short: -m
#:   arg: msg
#:   help: "Use the given <MSG> as the commit message."
#: - long: --from-index
#:   short: -i
#:   help: "Create a draft containing a copy of the index. (This is the only index-aware command.)"
#: - long: --delete-from-worktree
#:   short: -d
#:   help: "After creating the draft, remove any changes it contains from the worktree"
#: 
#: examples:
#: - git-draft create

create_get_draft_commit_message() {
	if [[ -v 'args[--message]' ]]; then
		git_draft get-commit-message --new --message="${args[--message]}"
	else
		git_draft get-commit-message --new
	fi
}

if [[ -v 'args[--from-index]' ]]; then
	index_tree="$(git write-tree)" # Get tree of current index
elif git_branch_has_commits; then
	index_tree="$(git rev-parse 'HEAD^{tree}')" # Use tree of current HEAD, with no changes from worktree/index
else # No commits yet (orphan branch)
	index_tree="$(git hash-object -t tree /dev/null)"
fi

if git_branch_has_commits; then
	parent="$(git rev-parse HEAD)"
	draft_commit="$(git commit-tree "$index_tree" -p "$parent" -F <(create_get_draft_commit_message) </dev/null)"
else # No commits yet (orphan branch)
	draft_commit="$(git commit-tree "$index_tree" -F <(create_get_draft_commit_message) </dev/null)"
fi

# Annotate commit
git notes --ref=drafts-info add -m "Draft-on: $(git_serialize_head)" "$draft_commit"

draft_name="$(generate_draft_name)"

git update-ref "refs/drafts/$draft_name" "$draft_commit" ''

echo "created new draft $draft_name"

if [[ -v 'args[--delete-from-worktree]' ]]; then
	git_draft apply "$draft_name" --index --reverse
fi
