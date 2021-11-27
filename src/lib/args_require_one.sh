args_require_one() {
	declare -i count=0
	for arg in "$@"; do
		if [[ -v "args[${arg}]" ]]; then
			count=$count+1
		fi
	done
	if [[ "$count" != 1 ]]; then
		echo "Exactly one of the following must be passed: $*" >&2
		exit 1
	fi
}
