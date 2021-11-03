#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create -m 'example draft'
git-draft list

echo 'x' > a.txt
git-draft list

GIT_DRAFT_TEST_RANDOM_6CHAR=ghijkl git-draft switch main-abcdef
git-draft list
