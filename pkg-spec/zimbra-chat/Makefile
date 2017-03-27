########################################################################################################

ZIMBRA_THIRDPARTY_SERVER = zdev-vm008.eng.zimbra.com

stage: downloads/openchat.jar downloads/zal-dev-chat.jar downloads/com_zextras_chat_open.zip
	install -T -D  downloads/openchat.jar               $(PKG_STAGE_DIR)/opt/zimbra/lib/ext/openchat/openchat.jar
	install -T -D  downloads/zal-dev-chat.jar           $(PKG_STAGE_DIR)/opt/zimbra/lib/ext/openchat/zal-dev.jar
	install -T -D  downloads/com_zextras_chat_open.zip  $(PKG_STAGE_DIR)/opt/zimbra/zimlets/com_zextras_chat_open.zip

downloads/openchat.jar:
	mkdir -p downloads
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/openchat.jar

downloads/com_zextras_chat_open.zip:
	mkdir -p downloads
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/com_zextras_chat_open.zip

downloads/zal-dev-chat.jar:
	mkdir -p downloads
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/zal-dev.jar

########################################################################################################
