#!/bin/bash
set -eu

# Load repository config via environment variables
source '/etc/restic/restic-env.sh'

echo "Pruning old restic snaphots"

# Check if repository is okay
restic check

restic prune

# Check if repository is okay
restic check

echo "Finished restic pruning"

exit 0