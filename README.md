reallyenglish-tinderbox-scripts
===============================

install helper scripts, make.conf(5) for builds and other files.

USAGE
=====

    > git clone git@github.com:reallyenglish/reallyenglish-tinderbox-scripts.git
    > cd reallyenglish-tinderbox-scripts
    # make

builds
------

install make.conf(5) for each builds.

hooks
-----

install and register hooks. the file name of a hook must be the name of the
hook.

portstrees
----------

install update.sh for each portstree.

env
---

install ${TBROOT}/scripts/env/etc files.

OptionsNG
---------

see https://wiki.freebsd.org/Ports/Options/OptionsNG

find out ${UNIQUENAME} for the port.

    > cd $YOURPORTSTREE
    > make -C www/apache22 -V UNIQUENAME
    apache22

add your options to env file

    > cd -
    > vim env/build.9.1-tomoyukis
    ...
    > cat env/build.9.1-tomoyukis
    apache22_SET="LDAP"

if ${UNIQUENAME} contains "-", this does not work. see BUGS section.

BUGS
====

conditional, or per-port, environment variable is not supported by tinderbox.

when ${UNIQUENAME} contains "-", such as rubygem-foo, there is no way to set
options for that port.

