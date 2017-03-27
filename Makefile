########################################################################################################

PKG_SPEC_DIR = pkg-spec

ifeq ($(PKG_RELEASE),)
   $(error "PKG_RELEASE not defined; Example: make 'PKG_RELEASE=1zimbra8.8b1' ...")
endif

.PHONY: clean all

all: zimbra-drive-pkg zimbra-chat-pkg

zimbra-drive-pkg:
	../zm-pkg-tool/pkg-build.pl \
	   --cfg-dir=./$(PKG_SPEC_DIR) \
	   --out-base-dir=build \
	   --pkg-version=1.0.2 \
	   --pkg-release=$(PKG_RELEASE) \
	   --pkg-name=zimbra-drive \
	   --pkg-summary="Zimbra Drive Extensions" \
	   --pkg-depends-list='zimbra-core' \
	   --pkg-install-list='/opt/zimbra/lib/ext/zimbradrive' \
	   --pkg-install-list='/opt/zimbra/lib/ext/zimbradrive/*' \
	   --pkg-install-list='/opt/zimbra/zimlets/*'

zimbra-chat-pkg:
	../zm-pkg-tool/pkg-build.pl \
	   --cfg-dir=./$(PKG_SPEC_DIR) \
	   --out-base-dir=build \
	   --pkg-version=1.0.2 \
	   --pkg-release=$(PKG_RELEASE) \
	   --pkg-name=zimbra-chat \
	   --pkg-summary="Zimbra Chat Extensions" \
	   --pkg-depends-list='zimbra-core' \
	   --pkg-install-list='/opt/zimbra/lib/ext/openchat' \
	   --pkg-install-list='/opt/zimbra/lib/ext/openchat/*' \
	   --pkg-install-list='/opt/zimbra/zimlets/*'

clean:
	rm -rf build
	rm -rf downloads

########################################################################################################
