########################################################################################################

SHELL = bash

.PHONY: clean all

########################################################################################################

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

########################################################################################################

stage-drive: downloads/zimbradrive-extension.jar downloads/zal_drive.jar downloads/com_zextras_drive_open.zip
	$(MAKE) TRACK_IN="$^" TRACK_OUT=drive gen-hash-track
	install -T -D downloads/zimbradrive-extension.jar  build/stage/zimbra-drive/opt/zimbra/lib/ext/zimbradrive/zimbradrive-extension.jar
	install -T -D downloads/zal_drive.jar              build/stage/zimbra-drive/opt/zimbra/lib/ext/zimbradrive/zal.jar
	install -T -D downloads/com_zextras_drive_open.zip build/stage/zimbra-drive/opt/zimbra/zimlets/com_zextras_drive_open.zip

zimbra-drive-pkg: stage-drive require-pkg-release
	../zm-pkg-tool/pkg-build.pl \
	   --pkg-version=1.0.7+$(shell git log --format=%at -1 hash-track/drive.hash) \
	   --pkg-release=$(PKG_RELEASE) \
	   --pkg-name=zimbra-drive \
	   --pkg-summary="Zimbra Drive Extensions" \
	   --pkg-depends='zimbra-store' \
	   --pkg-installs='/opt/zimbra/lib/ext/zimbradrive' \
	   --pkg-installs='/opt/zimbra/lib/ext/zimbradrive/*' \
	   --pkg-installs='/opt/zimbra/zimlets/*'

########################################################################################################

stage-chat: downloads/openchat.jar downloads/com_zextras_chat_open.zip downloads/zal_chat.jar
	$(MAKE) TRACK_IN="$^" TRACK_OUT=chat gen-hash-track
	install -T -D downloads/openchat.jar               build/stage/zimbra-chat/opt/zimbra/lib/ext/openchat/openchat.jar
	install -T -D downloads/zal_chat.jar               build/stage/zimbra-chat/opt/zimbra/lib/ext/openchat/zal.jar
	install -T -D downloads/com_zextras_chat_open.zip  build/stage/zimbra-chat/opt/zimbra/zimlets/com_zextras_chat_open.zip

zimbra-chat-pkg: stage-chat require-pkg-release
	../zm-pkg-tool/pkg-build.pl \
	   --pkg-version=1.0.7+$(shell git log --format=%at -1 hash-track/chat.hash) \
	   --pkg-release=$(PKG_RELEASE) \
	   --pkg-name=zimbra-chat \
	   --pkg-summary="Zimbra Chat Extensions" \
	   --pkg-depends='zimbra-store' \
	   --pkg-installs='/opt/zimbra/lib/ext/openchat' \
	   --pkg-installs='/opt/zimbra/lib/ext/openchat/*' \
	   --pkg-installs='/opt/zimbra/zimlets/*'

########################################################################################################

ZIMBRA_THIRDPARTY_SERVER = zdev-vm008.eng.zimbra.com

downloads/openchat.jar:
	mkdir -p downloads/
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/chat/current/openchat.jar

downloads/com_zextras_chat_open.zip:
	mkdir -p downloads/
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/chat/current/com_zextras_chat_open.zip

downloads/zal_chat.jar:
	mkdir -p downloads/
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/chat/current/zal.jar

downloads/zimbradrive-extension.jar:
	mkdir -p downloads/
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/drive/current/zimbradrive-extension.jar

downloads/com_zextras_drive_open.zip:
	mkdir -p downloads/
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/drive/current/com_zextras_drive_open.zip

downloads/zal_drive.jar:
	mkdir -p downloads/
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/drive/current/zal.jar

########################################################################################################

gen-hash-track:
	mkdir -p hash-track/
	sha512sum $(TRACK_IN) > hash-track/$(TRACK_OUT).hash
	@if [ "$$(git status -s hash-track/$(TRACK_OUT).hash)" != "" ]; \
	then \
	   echo; \
           echo "ERROR: ---------------------------------------------------------------------"; \
	   echo "ERROR: DETECTED HASH CHANGE FOR $(TRACK_OUT) - CONFIRM AND COMMIT IT FIRST"; \
           echo "ERROR: ---------------------------------------------------------------------"; \
	   echo; \
	   exit 1; \
	fi

clean:
	rm -rf build
	rm -rf downloads

########################################################################################################
