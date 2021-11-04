#!/bin/bash
source "tests/test_lib"

# Put mock-editor in PATH
PATH="$PATH:$(realpath "$(dirname "$0")")"

test_init
test_init_git_fixture

git-draft get-commit-message --for-draft=active

git-draft message -m 'This is a test message'
git-draft get-commit-message --for-draft=active

GIT_EDITOR=mock-editor git-draft message --edit
git-draft get-commit-message --for-draft=active
