#: name: list
#: help: Print a list of drafts

if ! active_is_empty; then
	echo -n '* '
	if active_draft_has_name; then
		echo -n "$(bold "$(active_draft_name)") "
	else
		echo -n "$(bold active) "
	fi
	echo -n "$(git_draft describe active) "
	git_draft get-commit-message active | head -n1 # TODO get message properly
fi

git show-ref | cut -d' ' -f2- | (grep -E 'refs/drafts/'||true) | sed 's%refs/drafts/%%' | while read draft ; do
	echo -n "  $(bold "$draft") "
	echo -n "$(git_draft describe "$draft") "
	git log --oneline --format=%B -n 1 "refs/drafts/$draft" | head -n1 # TODO get message properly
done
