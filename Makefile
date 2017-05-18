########################################################################################################

SHELL = bash

PKG_SPEC_DIR = pkg-spec

.PHONY: clean all

all: zimbra-drive-pkg zimbra-chat-pkg

require-pkg-release:
	@if [ -z "$(PKG_RELEASE)" ]; \
	then \
	   echo; \
	   echo "ERROR: -------------------------------------------------"; \
	   echo "ERROR: PKG_RELEASE not defined                          "; \
	   echo "ERROR: Example: make 'PKG_RELEASE=1zimbra8.7b1' ...     "; \
	   echo "ERROR: -------------------------------------------------"; \
	   echo; \
	   exit 1; \
	fi

zimbra-drive-pkg: require-pkg-release
	../zm-pkg-tool/pkg-build.pl \
	   --cfg-dir=./$(PKG_SPEC_DIR) \
	   --out-base-dir=build \
	   --pkg-version=1.0.6 \
	   --pkg-release=$(PKG_RELEASE) \
	   --pkg-name=zimbra-drive \
	   --pkg-summary="Zimbra Drive Extensions" \
	   --pkg-depends-list='zimbra-store' \
	   --pkg-install-list='/opt/zimbra/lib/ext/zimbradrive' \
	   --pkg-install-list='/opt/zimbra/lib/ext/zimbradrive/*' \
	   --pkg-install-list='/opt/zimbra/zimlets/*'

zimbra-chat-pkg: require-pkg-release
	../zm-pkg-tool/pkg-build.pl \
	   --cfg-dir=./$(PKG_SPEC_DIR) \
	   --out-base-dir=build \
	   --pkg-version=1.0.6 \
	   --pkg-release=$(PKG_RELEASE) \
	   --pkg-name=zimbra-chat \
	   --pkg-summary="Zimbra Chat Extensions" \
	   --pkg-depends-list='zimbra-store' \
	   --pkg-install-list='/opt/zimbra/lib/ext/openchat' \
	   --pkg-install-list='/opt/zimbra/lib/ext/openchat/*' \
	   --pkg-install-list='/opt/zimbra/zimlets/*'

clean:
	rm -rf build
	rm -rf downloads

########################################################################################################
