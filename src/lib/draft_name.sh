random_6char() {
	tr -dc a-z </dev/urandom | head -c 6
}

generate_draft_name() {
	name=''
	until [ -n "$name" ] && ! git_ref_exists "refs/drafts/$name"; do
		name="$(git rev-parse --abbrev-ref HEAD)-$(random_6char)"
	done
	echo "$name"
}
