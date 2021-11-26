#: name: get-trailers
#: private: true
#: help: Get all trailer for a draft
#: args:
#: - name: draft-name
#:   required: true
#:   validate: draft

(
	echo # Needed to convince interpret-trailers that these *are* trailers
	if draft_is_active "${args[draft-name]}"; then
		(
			if [[ -e "$(active_draft_notes_file)" ]]; then
				cat "$(active_draft_notes_file)"
			fi
		) | git interpret-trailers --no-divider --if-exists replace --trailer "Draft-on: $(git_serialize_head)"
	else
		git notes --ref=drafts-info show "$(ref_from_name "${args[draft-name]}")"
	fi
) | git interpret-trailers --parse --no-divider
