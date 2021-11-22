#: name: get-trailer
#: private: true
#: help: Get a trailer for a draft by name
#: args:
#: - name: draft-name
#:   required: true
#:   validate: draft
#: - name: trailer-name
#:   required: true
#:   validate: not_empty
#: flags:
#: - long: --default
#:   arg: value
#:   help: Value to return if trailer does not exist

if [[ -v args[--default] ]]; then
	export search_use_default=1
	export search_default="${args[--default]}"
fi

git_draft get-commit-message --for-draft="${args[draft-name]}" --parse-trailers | search="${args[trailer-name]}" awk '
	BEGIN {
		seen = 0
		search = ENVIRON["search"] ": "
	}
	substr($0, 1, length(search)) == search {
		print substr($0, length(search)+1)
		seen++
	}
	END {
		if (seen == 0 && ENVIRON["search_use_default"]) {
			print ENVIRON["search_default"]
		} else if (seen != 1) {
			print "Found " seen " results for trailer \"" ENVIRON["search"] "\"" > "/dev/stderr"
			exit 1
		}
	}
'
