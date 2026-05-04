#!/bin/sh

TAGS=$1

if [ -z "${TAGS}" ]
then
 echo "Missing required tags parameter"
 exit 1
fi

set -x
ansible-playbook -K --vault-password-file vault-passwd -l r740xd playbooks/r740xd.yml -t ${TAGS}

set +x
