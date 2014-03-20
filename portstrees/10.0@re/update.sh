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

    mylog "creating INDEX file for each build using branch ${GIT_BRANCH}"
    ALL_BUILDS=$( listBuilds )
    for BUILD in ${ALL_BUILDS}; do
        _PORTSTREE=${BUILD#*-}
        mylog "processing ${BUILD}, ${_PORTSTREE}"
        if [ x${_PORTSTREE} == x"${GIT_BRANCH}" ]; then
            mylog "${BUILD} is using branch ${GIT_BRANCH}"
            if [ -d ${TB_ROOT}/packages/${BUILD} ]; then
                # use "-a" to export all variables in env files
                sh -a -c "
                [ -f ${ENV_DIR}/build.${BUILD_NAME}-${GIT_BRANCH} ] && . ${ENV_DIR}/build.${BUILD_NAME}-${GIT_BRANCH}; \
                [ -f ${ENV_DIR}/portstree.${GIT_BRANCH} ] && . ${ENV_DIR}/${GIT_BRANCH}; \
                [ -f ${ENV_DIR}/GLOBAL ]                  && . ${ENV_DIR}/GLOBAL; echo ${RUBY_VER}; \
                make -C ${PORTSTREE} index \
                    INDEX_JOBS=${INDEX_JOBS} \
                    __MAKE_CONF=${TB_ROOT}/builds/make.conf.${BUILD} \
                    PORTSDIR=${PORTSTREE} \
                    INDEXDIR=${TB_ROOT}/packages/${BUILD}
                "
                # XXX INDEX-10 is hard-coded here. when you build packages for other major version, you need to define INDEXFILE
                cp ${TB_ROOT}/packages/${BUILD}/INDEX-10 ${TB_ROOT}/packages/${BUILD}/INDEX
                bzip2 -k -f ${TB_ROOT}/packages/${BUILD}/INDEX
            else
                mylog "but ${BUILD} does not have package directory (${TB_ROOT}/packages/${BUILD})"
            fi
        else
            mylog "${BUILD} is not using branch ${GIT_BRANCH}"
        fi
    done
fi
