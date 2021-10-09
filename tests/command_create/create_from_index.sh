#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

echo 'foo' > a.txt
echo 'bar' > b.txt
echo 'baz' > c.txt
echo 'bak' > d.txt

git add b.txt d.txt

GIT_DRAFT_TEST_RANDOM_6CHAR=abcdef git-draft create --from-index
git-draft show main-abcdef
git status
git diff
