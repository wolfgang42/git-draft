#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

echo 'foo' > a.txt
rm b.txt
echo 'bar' > c.txt

git status
git-draft status
