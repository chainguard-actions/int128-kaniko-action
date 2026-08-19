#!/bin/sh
# Fake docker: handle pull (no-op) and run (write fake digest to outputs dir)
# Supports volume mount parsing to find the outputs directory.
if [ "$1" = "pull" ]; then
  exit 0
fi
if [ "$1" = "run" ]; then
  outputs_host=""
  prev=""
  for arg in "$@"; do
    if [ "$prev" = "-v" ]; then
      case "$arg" in
        *:/kaniko/action/outputs|*:/kaniko/action/outputs:*)
          outputs_host="${arg%%:*}"
          ;;
      esac
    fi
    prev="$arg"
  done
  if [ -n "$outputs_host" ]; then
    printf '%s' "sha256:a948904f2f0f479b8f936065f3e9d0e7b3e8b3e8b3e8b3e8b3e8b3e8b3e8b3e8" > "$outputs_host/digest"
  fi
  exit 0
fi
exec /usr/bin/docker "$@"
