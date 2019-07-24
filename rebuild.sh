#!/bin/bash
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

machine=$(uname -m)
case $machine in
  i686)
    export MINGW_INSTALLS=mingw32
  ;;
  x86_64)
    export MINGW_INSTALLS=mingw64
  ;;
esac

function rebuild() {
  local _dir=$1
  cd $BASE_PATH
  cd $_dir

  rm -rf \
     src/ \
     pkg/ \
     *.pkg.tar.xz \
     *.src.tar.gz \
     logpipe.* \
     *.log \
     *.log.[0-9]*

  makepkg-mingw --noconfirm -sLf

  local _pkg_files=$(find . -type f -name "*.pkg.tar.xz")

  for _pkg_file in ${_pkg_files[@]}; do
    pacman -U --asdeps --noconfirm $_pkg_file
  done
}

rebuild $@
