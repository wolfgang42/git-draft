#!/bin/bash
source "tests/test_lib"

test_init
test_init_git_fixture

# change, stage, change
echo 'change1' > a.txt
git add a.txt
echo 'change2' > a.txt

# create, stage, change
echo 'change1' > new.txt
git add new.txt
echo 'change2' > new.txt

git status
git-draft status
