if [[ "$(git_draft active-is-empty)" != "y" ]]; then
	echo 'Switching with a non-empty active draft is not yet implemented' >&2
	exit 2
fi

git_draft activate-stashed "${args[draft-name]}"
