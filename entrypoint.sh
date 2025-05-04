#!/bin/bash

set -e
set -o pipefail

WORKSPACE="/github/workspace"
RELEASE_DIR="$WORKSPACE/release"
CUSTOM_SCRIPT="$WORKSPACE/customize.sh"

mkdir -p "${RELEASE_DIR}"

if [ -f "${CUSTOM_SCRIPT}" ]; then
  dos2unix "${CUSTOM_SCRIPT}"
  chmod +x "${CUSTOM_SCRIPT}"
  "${CUSTOM_SCRIPT}"
else
  su - build -c "yay -Syu $1 --noconfirm"
fi

if [ $? -eq 0 ]; then
  #find /home/build/.cache -name "*.zst" -exec mv {} "${RELEASE_DIR}" \;
  find /home/build/.cache -name "*.zst" | while read -r filepath; do
    filename=$(basename "$filepath")
    dir=$(dirname "$filepath")
    newname=$(echo "$filename" | sed -E 's/-[0-9]+:([0-9]+\.[0-9]+)/-\1/')
    mv "$filepath" "${RELEASE_DIR}/${newname}"
  done
else
  exit $?
fi
