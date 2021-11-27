#: name: get-commit-message
#: private: true
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
## NOTE - message flags are shared between message, commit, and get-commit-message commands
#: - long: --message
#:   short: -m
#:   arg: msg
#:   help: "Use the given <MSG> as the commit message. This will replace any existing message."
#: # Editing
#: - long: --edit
#:   short: -e
#:   help: "Open the commit message in an editor."
#: - long: --no-edit
#:   help: "Do not open the commit message in an editor."
#: - long: --auto-edit
#:   help: "Automatically decide whether to open an editor based on whether -m etc. were passed. Can be overridden by --edit/--no-edit."

args_require_one --from-stdin --new --for-draft # NOTE --message is *not* mutually exclusive with these, and will override them
args_mutually_exclusive --edit --no-edit # NOTE --auto-edit is *not* mutually exclusive with these, and will be overridden by them

should_edit=false
if [[ -v 'args[--edit]' ]]; then
	should_edit=true
elif [[ -v 'args[--no-edit]' ]]; then
	should_edit=false
elif [[ -v 'args[--auto-edit]' ]]; then
	should_edit=true
	if [[ -v 'args[--message]' ]]; then
		should_edit=false
	fi
fi

git_editor() {
	# Logic extracted from https://github.com/git/git/blob/8b7c11b8668b4e774f81a9f0b4c30144b818f1d1/editor.c
	# (but reshuffled to simplify it for a "good enough" version in this script)
	# NOTE this logic does not have any tests for it
	
	if [[ -z "$TERM" ]] || [[ "$TERM" == "dumb" ]]; then
		is_terminal_dumb=true
	else
		is_terminal_dumb=false
	fi
	
	if [[ -t 2 ]] && [[ "$(git config --type=bool --get advice.waitingForEditor || echo true)" == "true" ]]; then
		print_waiting_for_editor=true
	else
		print_waiting_for_editor=false
	fi
	
	if [[ "$print_waiting_for_editor" == "true" ]]; then
		if [[ "$is_terminal_dumb" == "true" ]]; then
			echo 'hint: Waiting for your editor to close the file... ' >&2
		else
			echo -n 'hint: Waiting for your editor to close the file... ' >&2
		fi
	fi
	
	if [[ -v 'GIT_EDITOR ]] && [[ "$GIT_EDITOR" == ':'' ]]; then
		: # Do nothing - it's not entirely clear to me *why* launch_specified_editor has this logic,
		: # but it does, so we duplicate it here.
	elif [[ -v 'GIT_EDITOR' ]]; then
		"$GIT_EDITOR" "$@"
	elif [[ -n "$(git config core.editor)" ]]; then
		"$(git config core.editor)" "$@"
	elif [[ "$is_terminal_dumb" != "true" ]] && [[ -v VISUAL ]]; then
		"$VISUAL" "$@"
	elif [[ -v 'EDITOR' ]]; then
		"$EDITOR" "$@"
	elif [[ "$is_terminal_dumb" == "true" ]]; then
		echo "Terminal is dumb, but EDITOR unset" >&2
		exit 1
	else
		vi "$@"
	fi
	
	if [[ "$print_waiting_for_editor" == "true" ]] && [[ "$is_terminal_dumb" != "true" ]]; then
		printf "\r\033[K" >&2
	fi
}

# Main pipeline - take a message and pass it through all the transforms it needs
(
	if [[ -v 'args[--message]' ]]; then
		echo "${args[--message]}"
	elif [[ -v 'args[--from-stdin]' ]]; then
		cat
	elif [[ -v 'args[--new]' ]]; then
		echo -n
	elif [[ -v 'args[--for-draft]' ]]; then
		if draft_is_active "${args[--for-draft]}"; then
			if [[ -e "$(active_draft_editmsg_file)" ]]; then
				cat "$(active_draft_editmsg_file)"
			fi
		else
			git show -s --format=%B "$(ref_from_name "${args[--for-draft]}")"
		fi
	fi
) | (
	# Interrupt for editing if appropriate
	# TODO put this with a well-known filename in .git and give it all the relevant hints that `git commit` would get
	if [[ "$should_edit" == true ]]; then
		tmpfile="$(git_dir)/GITDRAFT_TEMP_EDITMSG"
		cat >"$tmpfile"
		if [[ ! -v 'GIT_DRAFT_WITHOUT_TTY' ]]; then # TODO workaround for CI where we have no pty, there's probably a better way to do this
			git_editor "$tmpfile" </dev/tty >/dev/tty
		else
			git_editor "$tmpfile" </dev/null >/dev/null
		fi
		cat "$tmpfile"
		rm "$tmpfile"
	else
		cat
	fi
)
