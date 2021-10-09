active_draft_ref() {
	git symbolic-ref refs/git-draft/active # TODO consider memoizing
}

draft_ref_is_active() {
	[[ "$1" == "$(active_draft_ref)" ]]
}

draft_is_active() {
	draft_ref_is_active "refs/drafts/$1"
}
