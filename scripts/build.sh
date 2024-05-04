#!/bin/bash

set -e

PROJECT_DIR="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"

cd "$PROJECT_DIR" || exit 1

if [ -n "$PSR_DOCKER_GITHUB_ACTION" ]; then
    # PSR's Docker Action does not have the build requirements installed or access to
    # a virtual env so must re-install inside the container environment
    pip install -e .[build]
fi

printf '%s\n' "Building v$NEW_VERSION..."
export SETUPTOOLS_SCM_PRETEND_VERSION="$NEW_VERSION"
python3 -m build
