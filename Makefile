########################################################################################################

SHELL = bash

SHA512 = sha512sum

.PHONY: clean all

########################################################################################################

all: zimbra-drive-pkg zimbra-chat-pkg
	rm -rf build/stage build/tmp
	cd build/dist/[ucr]* && \
	if [ -f "/etc/redhat-release" ]; \
	then \
	   createrepo '.'; \
	else \
	   dpkg-scanpackages '.' /dev/null > Packages; \
	fi

########################################################################################################

DRIVE_VERSION = 1.0.11

stage-drive: downloads/drive/zimbradrive-extension.jar downloads/drive/zimbradrive-extension.conf.example downloads/drive/zal.jar downloads/drive/com_zextras_drive_open.zip 
	$(MAKE) TRACK_IN="$^" TRACK_OUT=drive gen-hash-track
	install -T -D downloads/drive/zimbradrive-extension.jar  build/stage/zimbra-drive/opt/zimbra/lib/ext/zimbradrive/zimbradrive-extension.jar
	install -T -D downloads/drive/zimbradrive-extension.conf.example  build/stage/zimbra-drive/opt/zimbra/lib/ext/zimbradrive/zimbradrive-extension.conf.example
	install -T -D downloads/drive/zal.jar                    build/stage/zimbra-drive/opt/zimbra/lib/ext/zimbradrive/zal.jar
	install -T -D downloads/drive/com_zextras_drive_open.zip build/stage/zimbra-drive/opt/zimbra/zimlets/com_zextras_drive_open.zip

zimbra-drive-pkg: stage-drive
	../zm-pkg-tool/pkg-build.pl \
           --out-type=binary \
	   --pkg-version=$(DRIVE_VERSION)+$(shell git log --format=%at -1 hash-track/drive.hash) \
	   --pkg-release=1 \
	   --pkg-name=zimbra-drive \
	   --pkg-summary="Zimbra Drive Extensions" \
	   --pkg-depends='zimbra-store' \
	   --pkg-installs='/opt/zimbra/lib/ext/zimbradrive' \
	   --pkg-installs='/opt/zimbra/lib/ext/zimbradrive/*' \
	   --pkg-installs='/opt/zimbra/zimlets/*'

downloads/drive/zimbradrive-extension.jar:
	mkdir -p downloads/drive
	wget -O $@ https://files.zimbra.com/repository/zextras/drive-$(DRIVE_VERSION)/zimbradrive-extension.jar

downloads/drive/zimbradrive-extension.conf.example:
	mkdir -p downloads/drive
	wget -O $@ https://files.zimbra.com/repository/zextras/drive-$(DRIVE_VERSION)/zimbradrive-extension.conf.example

downloads/drive/com_zextras_drive_open.zip:
	mkdir -p downloads/drive
	wget -O $@ https://files.zimbra.com/repository/zextras/drive-$(DRIVE_VERSION)/com_zextras_drive_open.zip

downloads/drive/zal.jar:
	mkdir -p downloads/drive
	wget -O $@ https://files.zimbra.com/repository/zextras/drive-$(DRIVE_VERSION)/zal.jar

########################################################################################################

CHAT_VERSION = 1.0.11

stage-chat: downloads/chat/openchat.jar downloads/chat/com_zextras_chat_open.zip downloads/chat/zal.jar
	$(MAKE) TRACK_IN="$^" TRACK_OUT=chat gen-hash-track
	install -T -D downloads/chat/openchat.jar               build/stage/zimbra-chat/opt/zimbra/lib/ext/openchat/openchat.jar
	install -T -D downloads/chat/zal.jar                    build/stage/zimbra-chat/opt/zimbra/lib/ext/openchat/zal.jar
	install -T -D downloads/chat/com_zextras_chat_open.zip  build/stage/zimbra-chat/opt/zimbra/zimlets/com_zextras_chat_open.zip

zimbra-chat-pkg: stage-chat
	../zm-pkg-tool/pkg-build.pl \
           --out-type=binary \
	   --pkg-version=$(CHAT_VERSION)+$(shell git log --format=%at -1 hash-track/chat.hash) \
	   --pkg-release=2 \
	   --pkg-name=zimbra-chat \
	   --pkg-summary="Zimbra Chat Extensions" \
	   --pkg-depends='zimbra-store' \
	   --pkg-installs='/opt/zimbra/lib/ext/openchat' \
	   --pkg-installs='/opt/zimbra/lib/ext/openchat/*' \
	   --pkg-installs='/opt/zimbra/zimlets/*'

downloads/chat/openchat.jar:
	mkdir -p downloads/chat
	wget -O $@ https://files.zimbra.com/repository/zextras/chat-$(CHAT_VERSION)/openchat.jar

downloads/chat/com_zextras_chat_open.zip:
	mkdir -p downloads/chat
	wget -O $@ https://files.zimbra.com/repository/zextras/chat-$(CHAT_VERSION)/com_zextras_chat_open.zip

downloads/chat/zal.jar:
	mkdir -p downloads/chat
	wget -O $@ https://files.zimbra.com/repository/zextras/chat-$(CHAT_VERSION)/zal.jar

########################################################################################################

gen-hash-track:
	mkdir -p hash-track/
	$(SHA512) $(TRACK_IN) > hash-track/$(TRACK_OUT).hash
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
