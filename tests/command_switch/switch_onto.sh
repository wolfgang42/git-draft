#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

echo 'foo' > a.txt
echo 'hi' > example.txt

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create

GIT_DRAFT_TEST_RANDOM_6CHAR=ghijkl git-draft switch main-abcdef --onto=HEAD^

git status
