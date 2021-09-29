#!/bin/bash
source "tests/test_lib"

test_init

echo 'hi' > example.txt

git-draft status
git-draft commit -m 'this is a test'
