#!/bin/sh
# Fake docker script that mocks kaniko executor behavior.
# - 'docker pull': no-op, exits 0
# - 'docker run': parses -v args to find the outputs dir, writes a fake digest

set -e

CMD="$1"
shift

case "$CMD" in
  --version|version)
    echo "Docker version 24.0.0-fake, build fake"
    exit 0
    ;;
  pull)
    # No-op: pretend the image was pulled successfully
    echo "Pulled image (fake)"
    exit 0
    ;;
  run)
    # Parse args to find the outputs volume mount: -v <hostDir>:/kaniko/action/outputs
    outputs_dir=""
    prev=""
    for arg in "$@"; do
      if [ "$prev" = "-v" ]; then
        # arg is like /some/path:/kaniko/action/outputs or /some/path:/kaniko/action/outputs:ro
        host_path="${arg%%:*}"
        rest="${arg#*:}"
        container_path="${rest%%:*}"
        if [ "$container_path" = "/kaniko/action/outputs" ]; then
          outputs_dir="$host_path"
        fi
      fi
      prev="$arg"
    done

    if [ -z "$outputs_dir" ]; then
      echo "fake-docker: could not find outputs dir in args: $*" >&2
      exit 1
    fi

    # Write a fake digest (sha256 of "fake")
    echo "sha256:2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae" > "${outputs_dir}/digest"
    echo "Built image (fake), digest written to ${outputs_dir}/digest"
    exit 0
    ;;
  *)
    echo "fake-docker: unknown command: $CMD" >&2
    exit 1
    ;;
esac
