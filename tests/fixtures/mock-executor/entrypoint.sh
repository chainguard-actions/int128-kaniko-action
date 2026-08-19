#!/bin/sh
# Mock kaniko executor: parses --digest-file arg and writes a fake digest
set -e

DIGEST_FILE=""
prev=""
for arg in "$@"; do
  if [ "$prev" = "--digest-file" ]; then
    DIGEST_FILE="$arg"
  fi
  prev="$arg"
done

if [ -n "$DIGEST_FILE" ]; then
  echo -n "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" > "$DIGEST_FILE"
fi

echo "Mock kaniko executor: build complete"
exit 0
