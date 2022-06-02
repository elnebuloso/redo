#!/bin/bash

set -e

: "${REEL_DOCKERCEPTION_BUILD_TAG:=container}"
: "${REEL_DOCKERCEPTION_BUILD_CONTEXT:=.}"
: "${REEL_DOCKERCEPTION_FILE_NAME:=Dockerfile}"
: "${REEL_DOCKERCEPTION_FILE_TARGET:=dev-composer}"
: "${REEL_DOCKERCEPTION_RUN_DIR:=.}"
: "${REEL_DOCKERCEPTION_RUN_WORKDIR:=/app}"

_ARGS_=()

while [ $# -gt 0 ]; do
  case "$1" in
  --REEL_DOCKERCEPTION_BUILD_TAG=*)
    REEL_DOCKERCEPTION_BUILD_TAG="${1#*=}"
    ;;
  --REEL_DOCKERCEPTION_BUILD_CONTEXT=*)
    REEL_DOCKERCEPTION_BUILD_CONTEXT="${1#*=}"
    ;;
  --REEL_DOCKERCEPTION_FILE_NAME=*)
    REEL_DOCKERCEPTION_FILE_NAME="${1#*=}"
    ;;
  --REEL_DOCKERCEPTION_FILE_TARGET=*)
    REEL_DOCKERCEPTION_FILE_TARGET="${1#*=}"
    ;;
  --REEL_DOCKERCEPTION_RUN_DIR=*)
    REEL_DOCKERCEPTION_RUN_DIR="${1#*=}"
    ;;
  --REEL_DOCKERCEPTION_RUN_WORKDIR=*)
    REEL_DOCKERCEPTION_RUN_WORKDIR="${1#*=}"
    ;;
  *)
    _ARGS_+=($1)
    ;;
  esac
  shift
done

_MD5_DOCKERFILE_=$(md5sum $REEL_DOCKERCEPTION_FILE_NAME | awk '{print $1}')

_TAG_ARGS_=()
_TAG_ARGS_+=("MD5_DOCKERFILE:$_MD5_DOCKERFILE_")
_TAG_ARGS_+=("REEL_DOCKERCEPTION_BUILD_TAG:$REEL_DOCKERCEPTION_BUILD_TAG")
_TAG_ARGS_+=("REEL_DOCKERCEPTION_BUILD_CONTEXT:$REEL_DOCKERCEPTION_BUILD_CONTEXT")
_TAG_ARGS_+=("REEL_DOCKERCEPTION_FILE_NAME:$REEL_DOCKERCEPTION_FILE_NAME")
_TAG_ARGS_+=("REEL_DOCKERCEPTION_FILE_TARGET:$REEL_DOCKERCEPTION_FILE_TARGET")

_TAG_=$(echo "${_TAG_ARGS_[*]}" | md5sum | awk '{print $1}')
_TAG_="reel_tmp_$REEL_DOCKERCEPTION_BUILD_TAG-$_TAG_"

_BUILD_=()
_BUILD_+=("docker")
_BUILD_+=("build")
_BUILD_+=("--rm")
_BUILD_+=("--pull")
_BUILD_+=("--file $REEL_DOCKERCEPTION_FILE_NAME")
_BUILD_+=("--target $REEL_DOCKERCEPTION_FILE_TARGET")
_BUILD_+=("--tag $_TAG_")
_BUILD_+=("$REEL_DOCKERCEPTION_BUILD_CONTEXT")

if [[ "$(docker images -q $_TAG_ 2>/dev/null)" == "" ]]; then
  if [[ ${REEL_VERBOSE_LEVEL} -ge 2 ]]; then
    echo -e "\e[36m${_BUILD_[*]}\e[0m"
  fi

  ${_BUILD_[*]}
fi

dockerception-run $REEL_DOCKERCEPTION_RUN_DIR $REEL_DOCKERCEPTION_RUN_WORKDIR $_TAG_ ${_ARGS_[*]}
