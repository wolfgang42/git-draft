#: name: apply
#: help: "Applies a draft to the working directory (like git apply)"
#: args:
#: - name: draft-name
#:   required: true
#:   validate: draft_stashed
#: flags:
#: # Flags that come from `git apply`: (TODO bring more in, these are just the ones we need for internal use)
#: - long: --check
#: - long: --3way
#:   short: '-3'
#: - long: --reverse
#:   short: '-R'
#: - long: --index

git_apply_args=()
for arg in --check --3way --reverse --index; do
	if [[ -v args["$arg"] ]]; then
		git_apply_args+=("$arg")
	fi
done
git_draft show "${args[draft-name]}" | git apply "${git_apply_args[@]}"
