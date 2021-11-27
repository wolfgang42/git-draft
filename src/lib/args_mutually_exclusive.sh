args_mutually_exclusive() {
	declare -i count=0
	for arg in "$@"; do
		if [[ -v "args[${arg}]" ]]; then
			count=$count+1
		fi
	done
	if [[ "$count" -gt 1 ]]; then
		echo "No more than one of the following must be passed: $*" >&2
		exit 1
	fi
}
