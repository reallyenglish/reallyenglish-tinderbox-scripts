SUBDIR=	builds hooks portstrees env

all:
.for D in ${SUBDIR}
	make -C ${D} ${.TARGET}
.endfor

.include "Makefile.inc"
