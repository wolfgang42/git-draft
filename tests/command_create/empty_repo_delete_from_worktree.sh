#!/bin/bash
source "tests/test_lib"

test_init
test_init_git

git status # Should be empty repo

echo 'foo' > a.txt
echo 'bar' > b.txt

git add b.txt

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create --from-index --delete-from-worktree
git-draft show main-abcdef
git status
