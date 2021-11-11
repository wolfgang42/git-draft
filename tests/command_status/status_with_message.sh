#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

git-draft message -m 'This is a commit message'
git-draft status
