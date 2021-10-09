if ( [[ -v args[draft-name] ]] && [[ -v args[--create] ]] ) || ( [[ ! -v args[draft-name] ]] && [[ ! -v args[--create] ]] ); then
	echo 'Exactly one of draft-name or --create must be passed' >&2
	exit 1
fi

if ! active_is_empty; then
	git_draft stash-active
fi

if [[ ! -v args[--create] ]]; then # Don't activate anything if we're creating a new draft
	git_draft activate-stashed "${args[draft-name]}"
fi
