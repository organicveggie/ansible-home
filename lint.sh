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

ANSIBLE_LINT_CONFIG="${SCRIPT_DIR}/.ansible-lint.yml"
YAMLLINT_CONFIG="${SCRIPT_DIR}/.yamllint"

set -x

yamllint -c ${YAMLLINT_CONFIG} -f github -s "${ROLE_DIR}"
ansible-lint -c ${ANSIBLE_LINT_CONFIG} \
    --yamllint-file ${YAMLLINT_CONFIG} \
    --exclude galaxy_roles/ \
    --exclude galaxy_collections/ \
    --format pep8 \
    "${ROLE_DIR}"

set +x