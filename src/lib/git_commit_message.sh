git_apply_active_trailers() {
	current_head="$(git symbolic-ref HEAD)"
	# Expects a commit message on stdin
	git interpret-trailers --no-divider --if-exists replace --trailer "Draft-on:$current_head"
}
