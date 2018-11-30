echo "Configuring Zimbra-OpenDrive"
echo "Checking if opendrive zimlet is installed."
su - zimbra -c "zmmailboxdctl status"
if [ $? -ne 0 ]; then
   echo "Mailbox is not running..."
   echo "Follow the steps below as zimbra user."
   echo "Remove the opendrive zimlet if it isinstalled."
   echo "zmzimletctl undeploy com_zextras_drive_open"
   echo "Install the Zimbra Open Drive zimlet."
   echo "zmzimletctl deploy /opt/zimbra/zimlets/com_zextras_drive_open.zip"
else
   su - zimbra -c  "zmzimletctl  -l listZimlets" | grep -e "com_zextras_drive_open"
   if [ "$?" -eq "0" ]; then
      echo "removing the opendrive zimlet.."
      su - zimbra -c  "zmzimletctl undeploy com_zextras_drive_open"
   fi
   echo "Deploying Zimbra-Opendrive zimlet"
   su - zimbra -c  "zmzimletctl deploy /opt/zimbra/zimlets/com_zextras_drive_open.zip"
   su - zimbra -c  "zmprov fc zimlet"
fi
echo "Restart the mailbox service as zimbra user. Run" 
echo "su - zimbra"
echo "zmmailboxdctl restart"
