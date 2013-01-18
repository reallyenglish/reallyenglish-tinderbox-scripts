PORTSTREES!=	find . -type d -depth 1 | sed -e 's/\.\///'
all:
.for P in ${PORTSTREES}
	if [ -f ${P}/update.sh ]; then \
	    	if [ -d ${PORTSTREE_DIR}/${P} ]; then \
			${INSTALL_BIN} ${P}/update.sh ${PORTSTREE_DIR}/${P}; \
		else \
			@echo "error: ${P}/update.sh exists but ${PORTSTREE_DIR}/${P} does not" >&2; \
			@echo "createPortsTree \"${P}\" first" >&2; \
			exit 1; \
		fi \
	fi
.endfor

.include "${.CURDIR}/../Makefile.inc"
