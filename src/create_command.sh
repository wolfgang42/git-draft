if [[ -v args[--from-index] ]]; then
	# Make a commit out of the index
	current_head="$(git rev-parse --symbolic-full-name HEAD)"
	index_tree="$(git write-tree)"
	parent="$(git rev-parse HEAD)"
	draft_commit="$(git commit-tree "$index_tree" -p "$parent" -m "Draft-on: $current_head" </dev/null)"
else
	draft_commit="$(git rev-parse HEAD)" # TODO actually I think this should be a blank commit *on* HEAD
fi

draft_name="$(generate_draft_name)"

git update-ref "refs/drafts/$draft_name" "$draft_commit" ''

echo "created new draft $draft_name"
