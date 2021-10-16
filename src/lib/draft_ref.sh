ref_from_name() {
	if [[ "$1" == "active" ]]; then
		echo "Draft name 'active' cannot be used as a ref" >&2
		exit 1
	elif [[ "$1" == refs/drafts/* ]]; then
		echo "$1"
	else
		echo "refs/drafts/$1"
	fi
}
