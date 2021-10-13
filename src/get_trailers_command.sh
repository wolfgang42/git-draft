#: name: get-trailers
#: help: Get trailers for a draft (see git-interpret-trailers(1) for details)
#: args:
#: - name: draft-name
#:   required: true

git_draft get-commit-message "${args[draft-name]}" | git interpret-trailers --parse --no-divider
