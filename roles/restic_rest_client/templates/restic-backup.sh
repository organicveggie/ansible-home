#!/bin/bash
set -eu

# Load repository config via environment variables
source '/etc/restic/restic-env.sh'

echo "Starting restic backup"

# Check if repository is okay
restic check

# Create new backup
export RESTIC_PROGRESS_FPS=0.016666
restic backup \
       --one-file-system \
       --exclude-caches \
       --files-from '{{ restic_client_backup_includes_file }}' \
       --exclude-file '{{ restic_client_backup_excludes_file }}' \
       --tag automated \
       --json

echo "Finished restic backup"

exit 0