#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

git checkout --detach

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create
git-draft show 61225ad-abcdef
