#: name: list
#: help: Print a list of drafts

GIT_DRAFT_CACHE_ACTIVE_REF="$(active_draft_ref)"
export GIT_DRAFT_CACHE_ACTIVE_REF

if ! active_is_empty; then
	echo -n '* '
	if active_draft_has_name; then
		echo -n "$(bold "$(active_draft_name)") "
	else
		echo -n "$(bold active) "
	fi
	echo -n "[$(git_draft describe active)] "
	# shellcheck disable=SC2005
	# ^ TODO needed so blank commit messages get displayed properly, though this is a hack
	echo "$(git_draft get-commit-message --for-draft=active | head -n1)" # TODO get message properly
fi

# shellcheck disable=SC2030
# ^ shellcheck is buggy here, see https://github.com/koalaman/shellcheck/issues/2390
git show-ref | cut -d' ' -f2- | (grep -E 'refs/drafts/'||true) | sed 's%refs/drafts/%%' | while read -r draft ; do
	echo -n "  $(bold "$draft") "
	echo -n "[$(git_draft describe "$draft")] "
	# shellcheck disable=SC2005
	# ^ TODO needed so blank commit messages get displayed properly, though this is a hack
	echo "$(git log --oneline --format=%B -n 1 "refs/drafts/$draft" | head -n1)" # TODO get message properly
done
