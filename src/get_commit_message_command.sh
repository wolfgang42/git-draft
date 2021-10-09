if draft_is_active "${args[draft-name]}"; then
	if [[ -e "$(active_draft_editmsg_file)" ]]; then
		cat "$(active_draft_editmsg_file)"
	fi
	# Trailers
	echo
	current_head="$(git rev-parse --symbolic-full-name HEAD)"
	echo "Draft-on: $current_head"
else
	echo # TODO temporary workaround for improperly formatted trailers
	git show -s --format=%B "refs/drafts/${args[draft-name]}"
fi
