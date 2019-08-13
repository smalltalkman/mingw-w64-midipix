#!/bin/bash
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

case $1 in
  "-32")
    machine=i686
    shift
  ;;
  "-64")
    machine=x86_64
    shift
  ;;
  *)
    machine=$(uname -m)
  ;;
esac

pacman -S --asdeps --needed --noconfirm mingw-w64-${machine}-gcc

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
  [[ ! -f $_dir/PKGBUILD ]] && echo "error: Invalid directory!" && exit
  cd $_dir

  rm -rf \
     src/ \
     pkg/ \
     mingw-w64-${machine}-*.pkg.tar.xz \
     *.src.tar.gz \
     logpipe.* \
     mingw-w64-*-${machine}-*.log \
     *.log.[0-9]*

  updpkgsums

  makepkg-mingw --noconfirm -sLf

  local _pkg_files=$(find . -type f -name "mingw-w64-${machine}-*.pkg.tar.xz")

  for _pkg_file in ${_pkg_files[@]}; do
    pacman -U --asdeps --noconfirm $_pkg_file
  done
}

rebuild $@
