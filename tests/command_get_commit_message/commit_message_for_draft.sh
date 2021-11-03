#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create -m 'example draft'
git-draft get-commit-message --for-draft=main-abcdef

git-draft get-commit-message --new --with-active-trailers

git-draft switch main-abcdef
git-draft get-commit-message --for-draft=active
