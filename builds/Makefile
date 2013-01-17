SRCS!=	/bin/ls make.conf.*

all:
.for S in ${SRCS}
	${INSTALL_SHARED} ${S} ${BUILDS_DIR}
.endfor

diff:
.for S in ${SRCS}
	diff -Nru ${S} ${BUILDS_DIR}/${S}
.endfor

.include "${.CURDIR}/../Makefile.inc"
