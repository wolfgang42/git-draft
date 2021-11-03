#!/bin/bash
source "tests/test_lib"

test_init

echo 'Hi' | git-draft get-commit-message --from-stdin

echo 'Hi' | git-draft get-commit-message --from-stdin --add-trailer 'Test-trailer:hello'

cat <<HERE | git-draft get-commit-message --from-stdin
This is a multi-line commit message.

It has several paragraphs.

Also: a trailer
HERE

cat <<HERE | git-draft get-commit-message --from-stdin --remove-trailer Trailer
Commit message

Trailer: should be removed
HERE

echo 'Hi' | git-draft get-commit-message --from-stdin -m 'This message will overwrite'

cat <<HERE | git-draft get-commit-message --from-stdin -m 'This message will overwrite'
Commit message

Trailer: should stay behind
HERE

cat <<HERE | git-draft get-commit-message --from-stdin --parse-trailers
Commit message

Trailer: here
Another: trailer
HERE
