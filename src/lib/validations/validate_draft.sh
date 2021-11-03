validate_draft() {
	# TODO this is a klunky way of doing it
	draft_is_active "$1" || git_ref_exists "$(ref_from_name "$1")" || echo "must be an existing draft"
}
