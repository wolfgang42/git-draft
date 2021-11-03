#: name: get-commit-message
#: help: Do various things with commit messages.
#: flags:
#: # Original message
#: - long: --for-draft
#:   arg: draft
#:   validate: draft
#:   help: "Read message from existing draft"
#: - long: --from-stdin
#:   help: "Read message from stdin"
#: - long: --new
#:   help: "Use a blank message"
#: # Additions to message
#: - long: --message
#:   short: -m
#:   arg: msg
#:   help: "Use the given <MSG> as the commit message. This will replace any existing message (but keeps trailers)."
#: # Trailers
#: - long: --with-active-trailers
#:   help: Apply trailers as though this is the active draft
#: - long: --add-trailer
#:   arg: trailer
#:   help: Add a trailer with the given name and value
#: - long: --remove-trailer
#:   arg: trailer-name
#:   help: Remove the trailer with the given name
#: - long: --parse-trailers
#:   help: Output trailers in convenient format

args_require_one --from-stdin --for-draft --new
args_mutually_exclusive --with-active-trailers --for-draft # Can't apply active trailers to other drafts
args_mutually_exclusive --clear --message

(
	# Read original message
	if [[ -v args[--from-stdin] ]]; then
		cat
	elif [[ -v args[--new] ]]; then
		echo -n
	elif [[ -v args[--for-draft] ]]; then
		if draft_is_active "${args[--for-draft]}"; then
			if [[ -e "$(active_draft_editmsg_file)" ]]; then
				cat "$(active_draft_editmsg_file)"
			fi
		else
			git show -s --format=%B "$(ref_from_name "${args[--for-draft]}")"
		fi
	fi
) | (
	# Add trailers for active draft
	if [[ -v args[--with-active-trailers] ]] || ( [[ -v args[--for-draft] ]] && draft_is_active "${args[--for-draft]}" ); then
		current_head="$(git symbolic-ref HEAD)"
		git interpret-trailers --no-divider --if-exists replace --trailer "Draft-on:$current_head"
	else
		cat
	fi
) | (
	# Replace message if requested
	if [[ -v args[--message] ]]; then
		echo "${args[--message]}"
		echo
		git interpret-trailers --only-trailers --only-input
	else
		cat
	fi
) | (
	# Add trailer if requested
	if [[ -v args[--add-trailer] ]]; then
		git interpret-trailers --no-divider --if-exists replace --trailer "${args[--add-trailer]}"
	else
		cat
	fi
) | (
	# Remove trailer if requested
	if [[ -v args[--remove-trailer] ]]; then
		git interpret-trailers --no-divider --if-exists=replace --trim-empty --trailer "${args[--remove-trailer]}:"
	else
		cat
	fi
) | (
	# Parse trailers if requested
	if [[ -v args[--parse-trailers] ]]; then
		git interpret-trailers --parse --no-divider
	else
		cat
	fi
)
