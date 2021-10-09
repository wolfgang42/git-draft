# shellcheck disable=SC2034
# ^ "appears unused" - it's not used in this file, but is elsewhere in the script
declare -r active_draft_ref=refs/git-draft/active

ref_from_name() {
	if [[ "$1" == refs/drafts/* ]]; then
		echo "$1"
	else
		echo "refs/drafts/$1"
	fi
}
