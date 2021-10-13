#: name: describe
#: help: Print a description of the draft
#: args:
#: - name: draft-name
#:   required: true

draft_name="${args[draft-name]}"

desc=()
if draft_is_active "$draft_name" && [[ "$(git_draft active-is-empty)" == "y" ]]; then
	desc+=("empty")
fi

desc+=("draft")

on_branch="$(git_draft get-trailer "$draft_name" "Draft-on")"

desc+=("on" "$(git rev-parse --abbrev-ref "$on_branch")")

if ! draft_is_active "$draft_name"; then
	draft_ref="$(ref_from_name "$draft_name")"
	behind="$(git rev-list --count "$draft_ref..$on_branch")"
	ahead="$(git rev-list --count "$on_branch..$draft_ref^")"
	if [[ "$ahead" == "0" && "$behind" != "0" ]]; then
		desc+=("(-$behind)")
	elif [[ "$ahead" != "0" && "$behind" == "0" ]]; then
		desc+=("(+$ahead)")
	elif [[ "$ahead" != "0" && "$behind" != "0" ]]; then
		desc+=("(-$behind/+$ahead)")
	fi
fi

echo "${desc[@]}"
