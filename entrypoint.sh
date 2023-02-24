#!/bin/bash

mkdir -p /github/workspace/release

if [ -f /github/workspace/customize.sh ]; then
  dos2unix /github/workspace/customize.sh
  chmod +x /github/workspace/customize.sh
  /github/workspace/customize.sh
else
  su - build -c "yay -Syu $1 --noconfirm"
fi

find /home/build/.cache -name *.zst | xargs -i mv {} /github/workspace/release

