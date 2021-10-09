draft_ref="refs/drafts/${args[draft-name]}"

desc=()
if draft_ref_is_active "$draft_ref" && [[ "$(git_draft active-is-empty)" == "y" ]]; then
	desc+=("empty")
fi

desc+=("draft")

on_branch="$(git_draft get-trailer "${args[draft-name]}" "Draft-on")"

desc+=("on" "$(git rev-parse --abbrev-ref "$on_branch")")

if ! draft_ref_is_active "$draft_ref"; then
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
