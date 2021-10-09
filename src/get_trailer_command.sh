git_draft get-trailers "${args[draft-name]}" | search="${args[trailer-name]}" awk '
	BEGIN {
		seen = 0
		search = ENVIRON["search"] ": "
	}
	substr($0, 1, length(search)) == search {
		print substr($0, length(search)+1)
		seen++
	}
	END {
		if (seen != 1) {
			print "Found " seen " results for trailer \"" ENVIRON["search"] "\"" > "/dev/stderr"
			exit 1
		}
	}
'
