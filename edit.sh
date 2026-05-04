#!/bin/sh

VAULT_FILE="$1"

if [ -z "${VAULT_FILE}" ]
then
 echo "Missing required vault file parameter"
 exit 1
fi

set -x
ansible-vault edit --vault-password-file vault-passwd "${VAULT_FILE}"

set +x
