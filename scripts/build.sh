#!/bin/bash

set -e

PROJECT_DIR="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"

cd "$PROJECT_DIR" || exit 1

if [ "${CI_JOB_ID:="-"}" = "-" ]; then
    echo >&2 "Error: CI_JOB_ID is missing from environment" && exit 1
fi

if [ "${APPLICATION_NAME:="-"}" = "-" ]; then
    echo >&2 "Error: APPLICATION_NAME is missing from environment" && exit 1
fi

if [ -n "$PSR_DOCKER_GITHUB_ACTION" ]; then
    # PSR's Docker Action does not have the build requirements installed or access to
    # a virtual env so must re-install inside the container environment
    pip install -e .[build]
fi

printf '%s\n' "Building v$NEW_VERSION..."
export SETUPTOOLS_SCM_PRETEND_VERSION="$NEW_VERSION"
python3 -m build
