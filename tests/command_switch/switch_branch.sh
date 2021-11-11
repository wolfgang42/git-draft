#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

echo 'foo' > a.txt
echo 'hi' > example.txt
git add -A
GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create  --from-index --delete-from-worktree

git switch -c branch2
echo 'bar' > a.txt
git commit -a -m 'branch2'

GIT_DRAFT_TEST_RANDOM_6CHAR=ghijkl git-draft switch main-abcdef

git status
