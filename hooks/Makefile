# SELECT hook_name FROM hooks ORDER BY hook_name;
HOOKS=	postBuildExtract \
	postJailBuild \
	postJailUpdate \
	postPortBuild \
	postPortChecksum \
	postPortsTreeUpdate \
	preBuildExtract \
	preJailBuild \
	preJailUpdate \
	prePortBuild \
	prePortChecksum \
	preAddPort \
	prePortsTreeUpdate \
	preTinderbuild

all:	install_dir
.for H in ${HOOKS}
	if [ -f ${H} ]; then \
	    ${INSTALL_BIN} ${H} ${HOOKS_DIR}; \
	    ${TC_CMD} updateHookCmd -h ${H} -c ${HOOKS_DIR}/${H}; \
	else \
	    ${TC_CMD} updateHookCmd -h ${H}; \
	fi
.endfor

install_dir:
	${INSTALL_DIR} ${HOOKS_DIR}

.include "${.CURDIR}/../Makefile.inc"
