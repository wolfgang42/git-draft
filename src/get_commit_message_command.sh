if draft_is_active "${args[draft-name]}"; then
	if [[ -e "$(git_dir)/DRAFT_MESSAGE" ]]; then
		cat "$(git_dir)/DRAFT_MESSAGE"
	fi
	# Trailers
	echo
	current_head="$(git rev-parse --symbolic-full-name HEAD)"
	echo "Draft-on: $current_head"
else
	git show -s --format=%B "refs/drafts/${args[draft-name]}"
fi
