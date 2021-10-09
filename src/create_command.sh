current_head="$(git rev-parse --symbolic-full-name HEAD)"
parent="$(git rev-parse HEAD)"
if [[ -v args[--from-index] ]]; then
	index_tree="$(git write-tree)" # Get tree of current index
else
	index_tree="$(git rev-parse HEAD^{tree})" # Use tree of current HEAD, with no changes from worktree/index
fi
draft_commit="$(git commit-tree "$index_tree" -p "$parent" -m "Draft-on: $current_head" </dev/null)"

draft_name="$(generate_draft_name)"

git update-ref "refs/drafts/$draft_name" "$draft_commit" ''

echo "created new draft $draft_name"

if [[ -v args[--delete-from-worktree] ]]; then
	git_draft apply "$draft_name" --reverse
fi
