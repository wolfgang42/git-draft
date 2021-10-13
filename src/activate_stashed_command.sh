#: name: activate-stashed
#: help: "Makes a stashed draft into the active draft (the current active draft must be an empty draft)"
#: args:
#: - name: draft-name

if ! active_is_empty; then
	echo 'Error: can only activate-stashed when an empty draft is active' >&2
	exit 2
fi

draft_ref="$(ref_from_name "${args[draft-name]}")"

# TODO make sure ref exists

# Update the working directory
git cherry-pick --no-commit --allow-empty "$draft_ref"
# Update the active draft commit message
git_draft get-commit-message "$draft_ref" > "$(active_draft_editmsg_file)"
# Set the active draft ref to the draft
git symbolic-ref "$active_draft_ref" "$draft_ref"
