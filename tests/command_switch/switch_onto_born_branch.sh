#!/bin/bash
source "tests/test_lib"

test_init
test_init_git

echo 'foo' > a.txt
git add -A
GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create  --from-index --delete-from-worktree

echo 'bar' > b.txt
git add -A
git commit -m 'First commit to main'

git switch --orphan branch2

GIT_DRAFT_TEST_RANDOM_6CHAR=ghijkl git-draft switch --onto-ref main-abcdef

git status
