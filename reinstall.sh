#!/bin/bash
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function reinstall() {
  local _dir=$1
  cd $BASE_PATH
  [[ ! -d $_dir ]] && echo "error: Invalid directory!" && exit
  cd $_dir

  local _pkg_files=$(find . -type f -name "*.pkg.tar.zst")

  for _pkg_file in ${_pkg_files[@]}; do
    pacman -U --asdeps --noconfirm $_pkg_file
  done
}

reinstall $@
