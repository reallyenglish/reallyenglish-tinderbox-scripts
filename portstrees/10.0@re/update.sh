#!/bin/sh
set -e
MYNAME=$0

TB_ROOT=/usr/local/tinderbox
SCPRIPTS_DIR=${TB_ROOT}/scripts
ENV_DIR=${SCPRIPTS_DIR}/etc/env
GIT_URL="https://github.com/reallyenglish/freebsd-ports.git"
GIT_BRANCH="10.0@re"
PORTSTREE_ROOT=${TB_ROOT}/portstrees/${GIT_BRANCH}
PORTSTREE=${PORTSTREE_ROOT}/ports
BUILD_NAME="10.0"
DEBUG=""
INDEX_JOBS="3"
#$( sysctl -n hw.ncpu )

listBuilds() {
    (cd ${TB_ROOT}/scripts && ./tc listBuilds)
}

mylog() {
    local TEXT="$*"
    local LOGGER_FLAGS="-t ${MYNAME}"
    if [ ! -z ${DEBUG} ]; then
        LOGGER_FLAGS="${LOGGER_FLAGS} -s"
    fi
    logger ${LOGGER_FLAGS} ${TEXT}
}

usage() {
}
ARGS=`getopt dh $*`
set -- $ARGS
while true; do
    case "$1" in
        -d)
            DEBUG=1
            shift
            ;;
        -h)
            usage
            ;;
        --)
            shift; break
            ;;
    esac
done

if [ ! -d ${PORTSTREE} ]; then
    mylog "directory ${PORTSTREE} does not exist, cloning ${GIT_URL} to ${PORTSTREE}"
    cd ${PORTSTREE_ROOT} && /usr/local/bin/git clone ${GIT_URL} ports
    mylog "checking our branch ${GIT_BRANCH}"
    cd ${PORTSTREE} && /usr/local/bin/git checkout ${GIT_BRANCH}
else
    mylog "checking out branch ${GIT_BRANCH} and pull"
    cd ${PORTSTREE} && /usr/local/bin/git checkout ${GIT_BRANCH} && /usr/local/bin/git pull
fi
