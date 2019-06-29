#!/bin/bash
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function do_echo() {
  local _begin_color="\033[31m"
  local _end_color="\033[0m"
  for _msg in "$@"; do
    echo -e "$_begin_color$_msg$_end_color"
  done
}

function reinstall_all() {
  if [ $# -lt 1 ]
  then
    readarray -t dirs < $BASE_PATH/rebuild_order
  else
    local dirs=("$@")
  fi

  for dir in ${dirs[@]}; do
    do_echo ">>> Reinstalling $dir <<<"
    $BASE_PATH/reinstall.sh $dir
  done
}

reinstall_all $@
