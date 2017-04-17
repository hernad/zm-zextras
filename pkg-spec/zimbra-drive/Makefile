########################################################################################################

ZIMBRA_THIRDPARTY_SERVER = zdev-vm008.eng.zimbra.com

stage: downloads/zimbradrive-extension.jar downloads/zal.jar downloads/com_zextras_drive_open.zip
	install -T -D  downloads/zimbradrive-extension.jar  $(PKG_STAGE_DIR)/opt/zimbra/lib/ext/zimbradrive/zimbradrive-extension.jar
	install -T -D  downloads/zal.jar                    $(PKG_STAGE_DIR)/opt/zimbra/lib/ext/zimbradrive/zal.jar
	install -T -D  downloads/com_zextras_drive_open.zip $(PKG_STAGE_DIR)/opt/zimbra/zimlets/com_zextras_drive_open.zip

downloads/zimbradrive-extension.jar:
	mkdir -p downloads
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/zimbradrive-extension.jar

downloads/com_zextras_drive_open.zip:
	mkdir -p downloads
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/com_zextras_drive_open.zip

downloads/zal.jar:
	mkdir -p downloads
	wget -O $@ http://$(ZIMBRA_THIRDPARTY_SERVER)/ZimbraThirdParty/zextras/zal.jar

########################################################################################################
