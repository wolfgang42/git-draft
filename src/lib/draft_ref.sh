declare -r active_draft_ref=refs/git-draft/active

ref_from_name() {
	if [[ "$1" == refs/drafts/* ]]; then
		echo $1
	else
		echo "refs/drafts/$1"
	fi
}
