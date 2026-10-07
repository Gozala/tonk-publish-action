#!/usr/bin/env bash
# Install the tonk CLI into the runner's temp directory and put it on PATH.
#
# TONK_VERSION: `latest`, `staging`, or a release tag. Uses tonk's own
# installer, which verifies the download against the release checksums.
set -euo pipefail

version="${TONK_VERSION:-latest}"
bin="${RUNNER_TEMP:?RUNNER_TEMP is not set}/tonk-bin"
mkdir -p "$bin"

case "$version" in
  latest) ;;
  staging) export TONK_CHANNEL=staging ;;
  v*) export TONK_RELEASE="$version" ;;
  *)
    echo "::error::tonk-version must be latest, staging, or a release tag like v0.7.0 (got '$version')"
    exit 1
    ;;
esac

export TONK_INSTALL_DIR="$bin"
curl -fsSL https://github.com/tonk-labs/tonk/releases/latest/download/install.sh | sh

echo "$bin" >>"$GITHUB_PATH"
"$bin/tonk" --version
