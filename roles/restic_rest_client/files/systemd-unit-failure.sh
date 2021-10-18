#!/bin/bash
set -eu

UNIT="$1"
EMAIL="$2"

# Get logs from last invocation
ID=$(systemctl show -p InvocationID --value "$UNIT")
LOGS="$(journalctl --no-hostname -o short-iso INVOCATION_ID=${ID} + _SYSTEMD_INVOCATION_ID=${ID})"

# Send email notification:
echo "$LOGS" | mail -s "Service $UNIT on $(hostname -f) failed!" "$EMAIL"

exit 0