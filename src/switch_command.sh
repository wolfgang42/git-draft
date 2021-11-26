#: name: switch
#: help: Make a different draft into the active draft (stashing the currently active one if it exists)
#: args:
#: - name: draft-name
#:   validate: draft
#: flags:
#: - long: --create
#:   short: -c
#:   help: "Switch to a new, empty draft"
#: # "--onto" flags
#: - long: --onto
#:   arg: commit-ish
#:   help: Check out COMMIT-ISH before un-stashing draft
#: - long: --onto-head
#:   help: Use current head to un-stash draft (do not check out anything else)
#: - long: --onto-ref
#:   help: Check out the branch that the draft was built on (this is the default). (This also works if the draft was on some kind of detached head, and will likewise detach.)
#: - long: --onto-detached-commit
#:   help: Check out the commit that the draft was built on as a detached HEAD
#:   
#: examples:
#: - git-draft switch main-episno

args_require_one draft-name --create
args_mutually_exclusive --onto --onto-head --onto-branch --onto-detached-commit

if ! active_is_empty; then
	git_draft stash
fi

if [[ -v args[--onto] ]]; then
	git checkout "${args[--onto]}"
elif [[ -v args[--onto-head] ]]; then
	: # Do nothing, keep current head
elif [[ -v args[--create] ]]; then
	# Everything from here down only applies to existing drafts, not --create
	args_mutually_exclusive --create --onto-branch --onto-detached-commit
elif [[ -v args[--onto-detached-commit] ]]; then
	git checkout "$(ref_from_name "${args[draft-name]}")^" # Checkout parent
else # --onto-branch, or no argument
	git_checkout_serialized_head "$(git_draft get-trailer "${args[draft-name]}" Draft-on)"
fi

if [[ ! -v args[--create] ]]; then # Don't activate anything if we're creating a new draft
	git_draft activate-stashed "${args[draft-name]}"
fi
