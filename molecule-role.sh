#!/bin/bash

ROLE=$1
if [ -z "${ROLE}" ]
then
 echo "Missing required role parameter"
 exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROLE_DIR="${SCRIPT_DIR}/roles/${ROLE}"
if [ ! -d "${ROLE_DIR}" ]; then
 echo "Role directory not found: ${ROLE_DIR}"
 exit 1
fi

set -x

pushd "${ROLE_DIR}"
ANSIBLE_KEEP_REMOTE_FILES=1 molecule "${@:2}"
popd

set +x