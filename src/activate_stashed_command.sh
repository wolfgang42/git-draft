if [[ "$(git_draft active-is-empty)" != "y" ]]; then
	echo 'Error: can only activate-stashed when an empty draft is active' >&2
	exit 2
fi

# TODO make sure ${args[draft-name]} exists

draft_ref="refs/drafts/${args[draft-name]}"

# Update the working directory
git cherry-pick --no-commit --allow-empty "$draft_ref"
# Update the active draft commit message
git_draft get-commit-message "${args[draft-name]}" > "$(active_draft_editmsg_file)"
# Set the active draft ref to the draft
git symbolic-ref refs/git-draft/active "$draft_ref"
