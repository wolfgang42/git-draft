random_6char() {
	if [[ -v GIT_DRAFT_TEST_RANDOM_6CHAR ]]; then
		echo "$GIT_DRAFT_TEST_RANDOM_6CHAR"
		return
	fi
	# shellcheck disable=SC2018
	# ^ we genuinely only want ASCII chars
	tr -dc a-z </dev/urandom | head -c 6
}

generate_draft_name() {
	name=''
	until [ -n "$name" ] && ! git_ref_exists "refs/drafts/$name"; do
		name="$(git rev-parse --abbrev-ref HEAD)-$(random_6char)"
	done
	echo "$name"
}
