#: name: status
#: short: st
#: help: Show working tree status, draft-aware version
#: 
#: examples:
#: - git-draft status

git status | head -n1
git_draft describe active
echo
if git_worktree_clean; then
	echo nothing to commit, working tree clean
else
	echo Changed files:
	while IFS= read -r line; do
		status="${line:0:2}"
		filename="${line:3}"
		case "$status" in
		# TODO enumerate all the statuses and put them here
		# (there's a helpful table in git-status(1))
		'??' | 'A ' | 'AM')
			echo $'\t'"$(green + "$filename")";;
		' M' | 'M ')
			echo $'\t'"$(blue '*' "$filename")";;
		' D' | 'D ')
			echo $'\t'"$(red '-' "$filename")";;
		*) # Unknown, mysterious status - display as-is
			echo $'\t'"$(yellow "($status)" "$filename")";;
		esac
	done <<< "$(git_changed_files)"
fi
