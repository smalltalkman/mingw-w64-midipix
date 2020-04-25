#!/bin/bash

machine=$(uname -m)

function clean() {
  rm -rf \
     src/ \
     pkg/ \
     mingw-w64-${machine}-*.pkg.tar.{xz,zst} \
     *.src.tar.gz \
     logpipe.* \
     mingw-w64-*-${machine}-*.log \
     *.log.[0-9]*
}

function build() {
  updpkgsums
  pacman -S --asdeps --needed --noconfirm mingw-w64-${machine}-gcc
  case $machine in
    i686)   export MINGW_INSTALLS=mingw32 ;;
    x86_64) export MINGW_INSTALLS=mingw64 ;;
  esac
  makepkg-mingw --noconfirm -sLf
}

function install() {
  local _pkg_files=$(find . -type f -name "mingw-w64-${machine}-*.pkg.tar.zst")
  for _pkg_file in ${_pkg_files[@]}; do
    pacman -U --asdeps --noconfirm $_pkg_file
  done
}

function execute() {
  local execute_dir=`pwd`
  while [ -n "$1" ]; do
    case $1 in
      "-d"     ) shift; cd $1 ; shift ;;
      "-32"    ) shift; machine=i686  ;;
      "-64"    ) shift; machine=x86_64;;
      "clean"  ) shift; clean   ;;
      "build"  ) shift; build   ;;
      "install") shift; install ;;
              *) break;;
    esac
  done
  cd $execute_dir
}

function do_execute() {
  case $1 in
    "-e") shift; execute    $@                     ;;
    "-d") shift; execute -d $@ clean build install ;;
    "-f") shift; local file=$1; shift;
      readarray -t dirs < $file
      for dir in ${dirs[@]}; do
        echo -e "\033[31m>>> (Re)Building $dir <<<\033[0m"
        execute -d $dir $@ clean build install
      done
    ;;
    "-i") shift; local file=$1; shift;
      readarray -t dirs < $file
      for dir in ${dirs[@]}; do
        echo -e "\033[31m>>> (Re)Installing $dir <<<\033[0m"
        execute -d $dir $@ install
      done
    ;;
  esac
}

do_execute $@
