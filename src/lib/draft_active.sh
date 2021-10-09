active_draft_ref() {
	git symbolic-ref refs/git-draft/active # TODO consider memoizing
}

draft_ref_is_active() {
	active_draft_has_name && [[ "$1" == "$(active_draft_ref)" ]]
}

draft_is_active() {
	draft_ref_is_active "refs/drafts/$1"
}

active_draft_has_name() {
	git show-ref refs/git-draft/active > /dev/null # TODO consider memoizing
}

active_is_empty() {
	[[ "$(git_draft active-is-empty)" == "y" ]]
}
