#!/bin/sh
# Fake docker: simulate kaniko behavior for testing
# Supports: docker pull <image>, docker run ... (with kaniko-style volume mounts)
if [ "$1" = "pull" ]; then
  echo "Pulled: $2"
  exit 0
fi
if [ "$1" = "run" ]; then
  outputs_dir=""
  prev=""
  for arg in "$@"; do
    if [ "$prev" = "-v" ]; then
      case "$arg" in
        *:/kaniko/action/outputs*)
          outputs_dir="${arg%%:*}"
          ;;
      esac
    fi
    prev="$arg"
  done
  if [ -n "$outputs_dir" ]; then
    echo "sha256:abc123def456abc123def456abc123def456abc123def456abc123def456abc1" > "$outputs_dir/digest"
  fi
  echo "Build completed (fake kaniko)"
  exit 0
fi
echo "Unknown docker command: $1"
exit 1
