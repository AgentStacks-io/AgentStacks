#!/usr/bin/env bash

# Determine OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  export OS_NAME="osx"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  export OS_NAME="windows"
else
  export OS_NAME="linux"
fi

# Set architecture if not already set
if [[ -z "${VSCODE_ARCH}" ]]; then
  if [[ "$(uname -m)" == "arm64" || "$(uname -m)" == "aarch64" ]]; then
    export VSCODE_ARCH="arm64"
  else
    export VSCODE_ARCH="x64"
  fi
fi

# Set quality (stable or insider)
export VSCODE_QUALITY="${VSCODE_QUALITY:-stable}"

# Determine if we should build
export SHOULD_BUILD="${SHOULD_BUILD:-yes}"
export SHOULD_BUILD_REH="${SHOULD_BUILD_REH:-yes}"
export SHOULD_BUILD_REH_WEB="${SHOULD_BUILD_REH_WEB:-yes}"

# CI/CD settings
export CI_BUILD="${CI_BUILD:-no}"

# Update settings
export DISABLE_UPDATE="${DISABLE_UPDATE:-no}"

echo "Build Configuration:"
echo "  OS: ${OS_NAME}"
echo "  Architecture: ${VSCODE_ARCH}"
echo "  Quality: ${VSCODE_QUALITY}"
echo "  Should Build: ${SHOULD_BUILD}"
echo "  CI Build: ${CI_BUILD}"