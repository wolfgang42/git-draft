validate_draft_stashed() {
	git_ref_exists "$(ref_from_name "$1")" || echo "must be a stashed draft"
}
