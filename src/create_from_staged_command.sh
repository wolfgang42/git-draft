if [ -z "$(git diff --staged)" ]; then
	git status # Show that there's no staged changes
	exit 1
fi

# Make a commit out of the index
current_head="$(git symbolic-ref HEAD)"
index_tree="$(git write-tree)"
parent="$(git rev-parse HEAD)"
commit="$(git commit-tree "$index_tree" -p "$parent" -m "Draft-on: $current_head" </dev/null)"

# Create a new draft out of the commit
draft_name="$(generate_draft_name)"
git update-ref "refs/drafts/$draft_name" "$commit" ''

# Remove the changes from the working directory by checking out the draft, then going back to the current head
# TODO this is an awkward way of doing it (and creates noise in the reflog),
# but I can't think of a better alternative right now
git checkout --quiet "$commit"
# The --merge flag is necessary to get git to not complain about needing to stash changes.
# This is safe (I think) because we just came from a state with these changes, so there can't be any merge conflicts
git checkout --quiet --merge "$current_head"

echo "created new draft $draft_name $(run describe "$draft_name")"
