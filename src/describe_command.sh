#: name: describe
#: private: true
#: help: Print a description of the draft
#: args:
#: - name: draft-name
#:   required: true
#:   validate: draft

draft_name="${args[draft-name]}"

desc=()
if draft_is_active "$draft_name" && [[ "$(git_draft active-is-empty)" == "y" ]]; then
	desc+=("empty")
fi

desc+=("draft")

draft_on="$(git_draft get-trailer "$draft_name" "Draft-on")"
draft_on_type="${draft_on%% *}" # Remove everything from first space to end of string
draft_on_value="${draft_on#* }" # Remove everything from start of string to first space

desc+=("on $draft_on_value")

if [[ "$draft_on_type" == "branch" ]] && ! draft_is_active "$draft_name"; then
	if git rev-parse --quiet --verify "$draft_on_value" > /dev/null; then
		draft_ref="$(ref_from_name "$draft_name")"
		behind="$(git rev-list --count "$draft_ref..$draft_on_value")"
		ahead="$(git rev-list --count "$draft_on_value..$draft_ref^")"
		if [[ "$ahead" == "0" && "$behind" != "0" ]]; then
			desc+=("(-$behind)")
		elif [[ "$ahead" != "0" && "$behind" == "0" ]]; then
			desc+=("(+$ahead)")
		elif [[ "$ahead" != "0" && "$behind" != "0" ]]; then
			desc+=("(-$behind/+$ahead)")
		fi
	else
		desc+=("(deleted branch)")
	fi
fi

echo "${desc[@]}"
