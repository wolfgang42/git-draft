# https://stackoverflow.com/questions/69935511/how-do-i-save-the-current-head-so-i-can-check-it-back-out-in-the-same-way-later

# Serialize HEAD into a string that can be stored, passed around, etc.
# and later used with the below function to get back that state.
git_serialize_head() {
	if branch="$(git symbolic-ref --quiet --short HEAD)"; then
		if git rev-parse --quiet --verify HEAD > /dev/null; then
			# On a branch
			echo "branch $branch"
		else
			# On an orphaned/unborn branch (have name, but no commits)
			echo "orphan $branch"
		fi
	else
		# Detached head
		echo "detach $(git rev-parse HEAD)"
	fi
}

# Take a string from the function above and apply it to the git repository.
git_checkout_serialized_head() {
	type="${1%% *}" # Remove everything from first space to end of string
	value="${1#* }" # Remove everything from start of string to first space
	
	if [[ "$type" == "branch" ]]; then
		git checkout "$value"
	elif [[ "$type" == "orphan" ]]; then
		# Note - though the branch was unborn when we serialized it, it may not
		# be any longer. Since `checkout --orphan` will complain if the branch
		# already exists, in this scenario check out that branch instead.
		# 
		# We still need to know if it was an orphan branch at serialization time,
		# though, because if it *wasn't* that means it was deleted in between
		# serialization and restoration, and the user probably doesn't want it to
		# come back as a new root in their repo. (The unqualified `git checkout`
		# in the type==branch case above will produce an error for us in this
		# situation.)
		if git rev-parse --quiet --verify HEAD > /dev/null; then
			# Not an orphan any more, check out normally
			git checkout "$value"
		else
			# Still an orphan, check out as such
			git checkout --orphan "$value"
		fi
	elif [[ "$type" == "detach" ]]; then
		git checkout --detach "$value"
	else
		echo "Unknown checkout type in serialized HEAD: $type" >&2
		echo "If the above value looks like a git ref, this draft was probably created with" >&2
		echo "an older version of git-draft; use 'git draft switch --onto' to resolve this." >&2
		exit 1
	fi
}
