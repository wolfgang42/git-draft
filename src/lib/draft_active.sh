active_draft_ref() {
	git_draft get-trailer active "Draft-ref" --default 'missing' # TODO consider memoizing
}

draft_ref_is_active() {
	[[ "$1" == "$(active_draft_ref)" ]]
}

draft_is_active() {
	[[ "$1" == "active" ]] || draft_ref_is_active "$(ref_from_name "$1")"
}

active_draft_has_name() {
	[[ "$(active_draft_ref)" != 'missing' ]]
}

active_draft_name() {
	active_draft_ref | sed 's%refs/drafts/%%'
}

active_is_empty() {
	[[ "$(git_draft active-is-empty)" == "y" ]]
}
