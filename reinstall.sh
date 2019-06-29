#!/bin/bash
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function reinstall() {
  local _dir=$1
  cd $BASE_PATH
  cd $_dir

  local _pkg_files=$(find . -type f -name "*.pkg.tar.xz")

  for _pkg_file in ${_pkg_files[@]}; do
    pacman -U --asdeps --noconfirm $_pkg_file
  done
}

reinstall $@
