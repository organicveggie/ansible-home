#!/bin/sh

ROLE_NAME="$1"

if [ -z "${ROLE_NAME}" ]
then
 echo "Missing required role_name parameter"
 exit 1
fi

set -x
ansible-galaxy role init "${ROLE_NAME}" --role-skeleton=role_skeleton/ --init-path roles/
set +x