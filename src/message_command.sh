#: name: message
#: short: m
#: help: Edit the active draft's commit message
#: flags:
## NOTE - message flags are shared between message, commit, and get-commit-message commands
#: # Additions to message
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

# NOTE - this command is also called directly by commit_command.sh; when changing this file make sure that the
#        alterations are compatible with that. (See comment in that file for details.)

get_message_args=()

# Flags with args
for flag in --message --file; do
	if [[ -v 'args["$flag"]' ]]; then
		get_message_args+=("$flag" "${args["$flag"]}")
	fi
done

# Flags without args
for flag in --edit --no-edit; do
	if [[ -v 'args["$flag"]' ]]; then
		get_message_args+=("$flag")
	fi
done

git_draft get-commit-message --for-draft=active --auto-edit "${get_message_args[@]}" > "$(active_draft_editmsg_file).tmp"
mv "$(active_draft_editmsg_file).tmp" "$(active_draft_editmsg_file)"
