#: name: list
#: help: Print a list of drafts

export GIT_DRAFT_CACHE_ACTIVE_REF="$(active_draft_ref)"

if ! active_is_empty; then
	echo -n '* '
	if active_draft_has_name; then
		echo -n "$(bold "$(active_draft_name)") "
	else
		echo -n "$(bold active) "
	fi
	echo -n "[$(git_draft describe active)] "
	echo "$(git_draft get-commit-message --for-draft=active | head -n1)" # TODO get message properly
fi

git show-ref | cut -d' ' -f2- | (grep -E 'refs/drafts/'||true) | sed 's%refs/drafts/%%' | while read draft ; do
	echo -n "  $(bold "$draft") "
	echo -n "[$(git_draft describe "$draft")] "
	echo "$(git log --oneline --format=%B -n 1 "refs/drafts/$draft" | head -n1)" # TODO get message properly
done
