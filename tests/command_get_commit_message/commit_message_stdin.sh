#!/bin/bash
source "tests/test_lib"

test_init

echo 'Hi' | git-draft get-commit-message --from-stdin

cat <<HERE | git-draft get-commit-message --from-stdin
This is a multi-line commit message.

It has several paragraphs.

Also: a trailer
HERE

echo 'Hi' | git-draft get-commit-message --from-stdin -m 'This message will overwrite'

cat <<HERE | git-draft get-commit-message --from-stdin -m 'This message will overwrite'
Commit message

Trailer: should stay behind
HERE
