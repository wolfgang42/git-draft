#!/bin/bash
source "tests/test_lib"

echo TODO this test is temporarily disabled
exit 0

test_init
test_init_git

echo 'hi' > example.txt

git-draft status
git-draft commit -m 'this is a test'
