#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

git status
git-draft status
