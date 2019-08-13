#!/bin/bash
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

case $1 in
  "-32")
    bit="-32"
    shift
  ;;
  "-64")
    bit="-64"
    shift
  ;;
esac

function do_echo() {
  local _begin_color="\033[31m"
  local _end_color="\033[0m"
  for _msg in "$@"; do
    echo -e "$_begin_color$_msg$_end_color"
  done
}

function rebuild_all() {
  if [ $# -lt 1 ]
  then
    readarray -t dirs < $BASE_PATH/rebuild_order
  else
    local dirs=("$@")
  fi

  for dir in ${dirs[@]}; do
    do_echo ">>> Rebuilding $dir <<<"
    $BASE_PATH/rebuild.sh $bit $dir
  done
}

rebuild_all $@
