#: name: activate-stashed
#: private: true
#: help: "Makes a stashed draft into the active draft (the current active draft must be an empty draft)"
#: args:
#: - name: draft-name
#:   required: true
#:   validate: draft_stashed

if ! active_is_empty; then
	echo 'Error: can only activate-stashed when an empty draft is active' >&2
	exit 2
fi

draft_ref="$(ref_from_name "${args[draft-name]}")"

# TODO make sure ref exists

# Update the working directory
git cherry-pick --no-commit --allow-empty "$draft_ref"
# Update the active draft commit message
git_draft get-commit-message --for-draft="$draft_ref" > "$(active_draft_editmsg_file)"
# Update the active draft notes
( # TODO this is a hack for compatibility and should be removed
	if [[ -v GIT_DRAFT_UNSTASH_IGNORE_NOTES ]]; then
		echo
	else
		git_draft get-trailers "$draft_ref"
	fi
) | git interpret-trailers --no-divider --if-exists replace --trailer "Draft-ref:$draft_ref" > "$(active_draft_notes_file)"
# Remove the draft commit, so it can't accidentally be used
git update-ref -d "$draft_ref"
