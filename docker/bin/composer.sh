#!/bin/bash

set -e

: "${REDO_COMPOSER_DIR:=main}"
: "${REDO_COMPOSER_DOCKER_BUILD_CONTEXT:=.}"
: "${REDO_COMPOSER_DOCKER_BUILD_ARGS:=--rm --pull}"
: "${REDO_COMPOSER_DOCKER_FILE_NAME:=Dockerfile}"
: "${REDO_COMPOSER_DOCKER_FILE_TARGET:=dev-composer}"

ARGUMENTS=""

while [ $# -gt 0 ]; do
  case "$1" in
    --REDO_COMPOSER_DIR=*)
      REDO_COMPOSER_DIR="${1#*=}"
      ;;
    --REDO_COMPOSER_DOCKER_BUILD_CONTEXT=*)
      REDO_COMPOSER_DOCKER_BUILD_CONTEXT="${1#*=}"
      ;;
    --REDO_COMPOSER_DOCKER_BUILD_ARGS=*)
      REDO_COMPOSER_DOCKER_BUILD_ARGS="${1#*=}"
      ;;
    --REDO_COMPOSER_DOCKER_FILE_NAME=*)
      REDO_COMPOSER_DOCKER_FILE_NAME="${1#*=}"
      ;;
    --REDO_COMPOSER_DOCKER_FILE_TARGET=*)
      REDO_COMPOSER_DOCKER_FILE_TARGET="${1#*=}"
      ;;
    *)
      ARGUMENTS="$ARGUMENTS $1"
  esac
  shift
done

: "${REDO_DOCKERCEPTION_BUILD_CONTEXT:=.}"
: "${REDO_DOCKERCEPTION_FILE_NAME:=Dockerfile}"
: "${REDO_DOCKERCEPTION_FILE_TARGET:=dev-composer}"
: "${REDO_DOCKERCEPTION_RUN_DIR:=.}"
: "${REDO_DOCKERCEPTION_RUN_WORKDIR:=/app}"

ARGS=""
ARGS="$ARGS --REDO_DOCKERCEPTION_BUILD_TAG=composer"
ARGS="$ARGS --REDO_DOCKERCEPTION_BUILD_CONTEXT=$REDO_COMPOSER_DOCKER_BUILD_CONTEXT"
ARGS="$ARGS --REDO_DOCKERCEPTION_FILE_NAME=$REDO_COMPOSER_DOCKER_FILE_NAME"
ARGS="$ARGS --REDO_DOCKERCEPTION_FILE_TARGET=$REDO_COMPOSER_DOCKER_FILE_TARGET"
ARGS="$ARGS --REDO_DOCKERCEPTION_RUN_DIR=$REDO_COMPOSER_DIR"
ARGS="$ARGS --REDO_DOCKERCEPTION_RUN_WORKDIR=/app"

dockerception-build-and-run $ARGS composer $ARGUMENTS
