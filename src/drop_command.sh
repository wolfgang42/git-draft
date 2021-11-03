#: name: drop
#: help: Delete a draft
#: args:
#: - name: draft-name
#:   required: true
#:   validate: draft_stashed

if draft_is_active "${args[draft-name]}"; then
	echo "Cannot drop an active draft." 2>&1
	exit 1
fi

draft_ref="refs/drafts/${args[draft-name]}"

commit="$(git rev-parse "$draft_ref")"

echo "Dropped $draft_ref ($commit)"

git update-ref -d "$draft_ref" "$commit"
