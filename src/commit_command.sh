#: name: commit
#: short: c
#: help: Commit the active draft
#:
#: flags:
## NOTE - message flags are shared between message, commit, and get-commit-message commands
#: - long: --message
#:   short: -m
#:   arg: msg
#:   help: "Use the given <MSG> as the commit message. This will discard the draft's message if it has one."
#: - long: --edit
#:   short: -e
#:   help: "Open the commit message in an editor."
#: - long: --no-edit
#:   help: "Do not edit the message before committing."
#:
#: examples:
#: - git-draft commit

# TODO support amend drafts
git add -A

# Set an environment variable that can be seen by git hooks, editors, etc during `git commit`,
# in case someone wants to know when a draft is being committed for some reason.
export GIT_DRAFT_COMMITTING=1

# Call message command directly:
# this is normally a weird thing to do, since it bypasses all of the argument handling etc., but
# 1. it's OK to do here because message_command uses a subset of commit's arguments and has been carefully
#    designed to be OK with this situation,
# 2. we do this because it's a little less awkward than copying over all the arguments, but if this proves
#    problematic for some reason it should be changed to just do that instead.
git_draft_message_command

git commit --no-edit -F <(git_draft get-commit-message --for-draft=active --remove-draft-trailers)

if ! git_worktree_clean; then
	echo 'Assertion error: worktree is not clean after git-draft commit!' >&2
	echo 'This is a bug; please report it (with steps to reproduce if possible).' >&2
	exit 2
fi

if [[ -e "$(active_draft_editmsg_file)" ]]; then
	# We've successfully made the commit, so the draft's commit message can be discarded
	rm "$(active_draft_editmsg_file)"
fi

if ! active_is_empty; then
	echo 'Assertion error: active draft is not empty after git-draft commit!' >&2
	echo 'This is a bug; please report it (with steps to reproduce if possible).' >&2
	exit 2
fi
