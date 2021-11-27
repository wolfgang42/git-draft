#: name: show
#: help: Show the contents of a draft
#: 
#: args:
#: - name: draft-name
#:   validate: draft

# TODO support active draft

git show --notes=drafts-info "refs/drafts/${args[draft-name]}"
