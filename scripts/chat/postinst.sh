echo "Configuring Zimbra-Chat"
echo "Checking if Talk zimlet is installed."
su - zimbra -c "zmmailboxdctl status"
if [ $? -ne 0 ]; then
   echo "Mailbox is not running..."
   echo "Follow the steps below as zimbra user."
   echo "Remove the talk zimlet if it isinstalled."
   echo "zmzimletctl undeploy com_zextras_talk"
   echo "Install the Zimbra Open Chat zimlet."
   echo "zmzimletctl deploy /opt/zimbra/zimlets/com_zextras_drive_open.zip"
elif
   su - zimbra -c  "zmzimletctl  -l listZimlets" | grep -e "com_zextras_talk"
   if [ "$?" -gt "0" ]; then
      echo "removing the talk zimlet.."
      su - zimbra -c  "zmzimletctl undeploy com_zextras_talk"
   fi
   echo "Deploying Zimbra-Chat zimlet"
   su - zimbra -c  "zmzimletctl deploy /opt/zimbra/zimlets/com_zextras_drive_open.zip"
   su - zimbra -c  "zmprov fc zimlet"
fi
echo "Restart the mailbox service as zimbra user. Run" 
echo "su - zimbra"
echo "zmmailboxdctl restart"
