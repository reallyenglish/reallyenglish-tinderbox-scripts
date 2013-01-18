SUBDIR=	builds hooks portstrees

all:
.for D in ${SUBDIR}
	make -C ${D} ${.TARGET}
.endfor

.include "Makefile.inc"
