#!/bin/bash

PACKAGE=github.com/lox/package-proxy

while [[ $1 == -* ]] ; do
  case "$1" in
    --build)    build=1 ;;
    --run)      run=1   ;;
  esac
  shift
done

if [ -n "$build" ] ; then
  docker build --tag="lox24/package-proxy" .
fi

if [ -n "$run" ] ; then
  docker rm -f package-proxy &>/dev/null || true
  docker run \
    --tty --interactive --rm \
    --name package-proxy \
    --publish 3142:3142 \
    --publish 3143:3143 \
    --env GITHUB_TOKEN=$GITHUB_TOKEN \
    --volume /projects/go/src/$PACKAGE:/go/src/$PACKAGE \
    --volume /tmp/vagrant-cache/generic/:/tmp/cache \
    --entrypoint "/run.sh" \
    lox24/package-proxy "$@"
fi