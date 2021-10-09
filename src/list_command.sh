if active_draft_has_name; then
	active_draft="$(git symbolic-ref refs/git-draft/active | sed 's%refs/drafts/%%')"
else
	active_draft=""
fi

git show-ref | cut -d' ' -f2- | grep -E 'refs/drafts/'||true | sed 's%refs/drafts/%%' | while read draft ; do
	if [[ "$draft" == "$active_draft" ]]; then
		echo -n '* '
	else
		echo -n '  '
	fi
	echo -n "$draft "
	echo -n "$(git_draft describe "$draft") "
	git log --oneline --format=%B -n 1 "refs/drafts/$draft" | head -n1 # TODO get message properly
done
