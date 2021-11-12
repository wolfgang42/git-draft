#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

git switch -c branch2
GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create
git switch main
git branch -d branch2

git draft show branch2-abcdef

git-draft describe branch2-abcdef
