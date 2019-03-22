#!/bin/bash

set -e

[ $# -eq 0 ] && set -- yocto

export LANG=en_US.UTF-8

if [ "$1" = "yocto" ]; then
    shift; set -- ${YOCTO_ENTRYPOINT} "$@"
fi

exec "$@"
