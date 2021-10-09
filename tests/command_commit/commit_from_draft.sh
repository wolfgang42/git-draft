#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

echo 'foo' > a.txt
git add -A
GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create -id
git-draft switch main-abcdef

git-draft list

git-draft commit -m 'make some changes'

git-draft list
echo "Active is empty: $(git-draft active-is-empty)"
