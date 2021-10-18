#!/bin/bash
set -eu

# Load repository config via environment variables
source '/etc/restic/restic-env.sh'

echo "Removing old restic snaphots for {{ real_hostname_short }}"

# Check if repository is okay
restic check

restic forget \
       --keep-hourly 24 \
       --keep-daily 7 \
       --keep-weekly 4 \
       --keep-monthly 6 \
       --host {{ real_hostname_short }}

# Check if repository is okay
restic check

echo "Finished restic snapshot removal"

exit 0