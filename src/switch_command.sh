#: name: switch
#: help: Make a different draft into the active draft (stashing the currently active one if it exists)
#: args:
#: - name: draft-name
#:   validate: draft
#: flags:
#: - long: --create
#:   short: -c
#:   help: "Switch to a new, empty draft"
#:   
#: examples:
#: - git-draft switch main-episno

args_require_one draft-name --create

if ! active_is_empty; then
	git_draft stash-active
fi

if [[ ! -v args[--create] ]]; then # Don't activate anything if we're creating a new draft
	git_draft activate-stashed "${args[draft-name]}"
fi
