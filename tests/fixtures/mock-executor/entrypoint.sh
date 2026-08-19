#!/bin/sh
# Mock Kaniko executor: find --digest-file argument and write a fake digest
set -e
prev=""
for arg in "$@"; do
  if [ "$prev" = "--digest-file" ]; then
    echo -n "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" > "$arg"
    echo "Mock Kaniko: wrote digest to $arg"
  fi
  prev="$arg"
done
echo "Mock Kaniko: build complete (no-op)"
