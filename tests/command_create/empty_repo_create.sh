#!/bin/bash
source "tests/test_lib"

test_init
test_init_git

git status # Should be empty repo

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create
git-draft show main-abcdef
