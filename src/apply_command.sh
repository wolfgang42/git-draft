git_apply_args=()
for arg in --check --3way --reverse --index; do
	if [[ -v args["$arg"] ]]; then
		git_apply_args+=("$arg")
	fi
done
git_draft show "${args[draft-name]}" | git apply "${git_apply_args[@]}"
