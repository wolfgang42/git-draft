#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create -m 'Commit message here'
git-draft switch main-abcdef

echo 'foo' > a.txt
echo 'hi' > example.txt

git-draft stash
git-draft show main-abcdef
git status
