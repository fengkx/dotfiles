#!/usr/bin/env bash

set -euo pipefail

REPOSRC='https://github.com/fengkx/dotfiles'
LOCALREPO="${HOME}/dotfiles"
LOCALREPO_VC_DIR="${LOCALREPO}/.git"

if [ ! -d "${LOCALREPO_VC_DIR}" ]; then
    git clone "${REPOSRC}" "${LOCALREPO}"
else
    git -C "${LOCALREPO}" pull --ff-only
fi

cd "${LOCALREPO}"

if command -v lkdots >/dev/null 2>&1; then
    lkdots
fi

bash "${LOCALREPO}/script/install-dev-runtimes.sh" "${LOCALREPO}"
