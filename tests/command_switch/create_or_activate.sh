#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create

set +e # We expect these to fail
git-draft switch -c main-abcdef
git-draft switch -c main-nonexistent
git-draft switch

exit 0 # Don't fail test
