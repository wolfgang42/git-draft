random_6char() {
	if [[ -v 'GIT_DRAFT_TEST_RANDOM_6CHAR' ]]; then
		echo "$GIT_DRAFT_TEST_RANDOM_6CHAR"
		return
	fi
	# shellcheck disable=SC2018
	# ^ we genuinely only want ASCII chars
	# Use the C locale to prevent certain systems (MacOS in particular) from trying
	# (and failing) to interpret the urandom output as UTF-8.
	LC_ALL=C tr -dc a-z </dev/urandom | head -c 6
}

generate_draft_name() {
	name=''
	until [ -n "$name" ] && ! git_ref_exists "refs/drafts/$name"; do
		name="$(git symbolic-ref -q --short HEAD || git rev-parse --short HEAD)-$(random_6char)"
	done
	echo "$name"
}
