#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

echo 'foo' > a.txt
echo 'hi' > example.txt
git add -A
GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create  --from-index --delete-from-worktree

echo 'bar' > b.txt
git commit -a -m 'change b'

GIT_DRAFT_TEST_RANDOM_6CHAR=ghijkl git-draft switch --onto-detached-commit main-abcdef

git status
