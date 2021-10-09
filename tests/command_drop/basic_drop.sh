#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create
GIT_DRAFT_TEST_RANDOM_6CHAR=ghijkl git-draft create
git-draft switch main-abcdef

git-draft list
git-draft drop main-abcdef || echo 'drop failed'
git-draft drop main-ghijkl
git-draft list
