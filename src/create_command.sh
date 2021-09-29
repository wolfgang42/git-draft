draft_name="$(generate_draft_name)"
git update-ref "refs/drafts/$draft_name" "$(git rev-parse HEAD)" ''
echo "created new draft $draft_name"
