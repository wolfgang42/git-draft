#: name: show
#: help: Show the contents of a draft
#: 
#: args:
#: - name: draft-name
#:   validate: draft

# TODO support active draft

git show refs/drafts/${args[draft-name]}
