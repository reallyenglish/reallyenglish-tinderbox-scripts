SRCS!=	find * -type f -name 'build.*' ; find * -type f -name 'jail.*'; find * -name 'portstree.*'; find * -type f -name 'GLOBAL'

all:	install_dir
.for S in ${SRCS}
	${INSTALL_SHARED} ${S} ${ENV_DIR}
.endfor

install_dir:
	${INSTALL_DIR} ${ENV_DIR}

.include "../Makefile.inc"
