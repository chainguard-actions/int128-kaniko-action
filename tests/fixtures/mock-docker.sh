#!/bin/sh
# Mock docker script for testing kaniko-action
# Intercepts 'docker pull' and 'docker run' calls
# For 'docker run', finds the output directory from -v args and writes a fake digest

set -e

CMD="$1"
shift

case "$CMD" in
  pull)
    # Silently succeed for any image pull
    echo "Mock: docker pull $* (skipped)"
    exit 0
    ;;
  run)
    # Parse arguments to find the output directory mount
    # The action mounts: -v <outputsDir>:/kaniko/action/outputs
    OUTPUT_HOST_DIR=""
    prev=""
    for arg in "$@"; do
      if [ "$prev" = "-v" ]; then
        # Check if this volume mount is for /kaniko/action/outputs
        case "$arg" in
          *:/kaniko/action/outputs*)
            OUTPUT_HOST_DIR="${arg%%:*}"
            ;;
        esac
      fi
      prev="$arg"
    done

    if [ -n "$OUTPUT_HOST_DIR" ]; then
      # Write a fake digest to the output directory
      mkdir -p "$OUTPUT_HOST_DIR"
      echo "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" > "$OUTPUT_HOST_DIR/digest"
      echo "Mock: docker run completed, wrote fake digest to $OUTPUT_HOST_DIR/digest"
    else
      echo "Mock: docker run completed (no output dir found)"
    fi
    exit 0
    ;;
  *)
    echo "Mock: docker $CMD $* (unknown command, succeeding)"
    exit 0
    ;;
esac
