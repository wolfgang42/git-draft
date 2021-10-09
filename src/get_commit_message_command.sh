draft_name="${args[draft-name]}"

if draft_is_active "$draft_name"; then
	(
		if [[ -e "$(active_draft_editmsg_file)" ]]; then
			cat "$(active_draft_editmsg_file)"
		fi
	) | git_apply_active_trailers
else
	git show -s --format=%B "$(ref_from_name "$draft_name")"
fi
