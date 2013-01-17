#!/bin/sh
set -e
MYNAME=$0

TB_ROOT=/usr/local/tinderbox
PORTSTREE_ROOT=${TB_ROOT}/portstrees/reallyenglish
PORTSTREE=${PORTSTREE_ROOT}/ports
GIT_URL="https://github.com/reallyenglish/freebsd-ports.git"
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
    mylog "checking our reallyenglish branch"
    cd ${PORTSTREE} && /usr/local/bin/git checkout reallyenglish
else
    mylog "checking out reallyenglish branch and pull"
    cd ${PORTSTREE} && /usr/local/bin/git checkout reallyenglish && /usr/local/bin/git pull

    mylog "creating INDEX file for each build using branch reallyenglish"
    ALL_BUILDS=$( listBuilds )
    for BUILD in ${ALL_BUILDS}; do
        _PORTSTREE=${BUILD#*-}
        mylog "processing ${BUILD}, ${_PORTSTREE}"
        if [ x${_PORTSTREE} == x"reallyenglish" ]; then
            mylog "${BUILD} is using branch reallyenglish"
            if [ -d ${TB_ROOT}/packages/${BUILD} ]; then
                # XXX INDEX-9 is hard-coded here. when you build packages for other major version, you need to define INDEXFILE
                make -C ${PORTSTREE} index \
                    INDEX_JOBS=${INDEX_JOBS} \
                    __MAKE_CONF=${TB_ROOT}/builds/make.conf.${BUILD} \
                    PORTSDIR=${PORTSTREE} \
                    INDEXDIR=${TB_ROOT}/packages/${BUILD}
                cp ${TB_ROOT}/packages/${BUILD}/INDEX-9 ${TB_ROOT}/packages/${BUILD}/INDEX
                bzip2 -k -f ${TB_ROOT}/packages/${BUILD}/INDEX
            else
                mylog "but ${BUILD} does not have package directory (${TB_ROOT}/packages/${BUILD})"
            fi
        else
            mylog "${BUILD} is not using branch reallyenglish"
        fi
    done
fi
