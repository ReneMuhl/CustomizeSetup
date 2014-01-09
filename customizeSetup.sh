#! /bin/bash

#constants
IMAGE_URL="http://cloud-images.ubuntu.com/precise/current/"
IMAGENAME="precise-server-cloudimg-amd64-disk1.img"

#variables
DOWNLOADFOLDER="images"
GLANCEIMAGENAME="ubuntu12.04.3LTS"
KEYPAIRNAME="default_key"

#Download des Cloud Image
if [ -f "$DOWNLOADFOLDER"/"$IMAGENAME" ]
then
            echo "Image existiert bereits"
else
        echo "Image (~243MB) wird jetzt gedownloadet"
        wget -P"$DOWNLOADFOLDER" "$IMAGE_URL""$IMAGENAME"
        echo "Image wurde downloadet und befindet sich jetzt im Ordner:" "$DOWNLOADFOLDER"
fi

#Laden der Umgebungsvariablen zur Authentifizierung
source ~/openstackrc-demo

#Hinzufügen des Images zu OpenStack Image-Service Glance
ISIMAGEADDED=`glance index | awk '{print $2}' | grep -E "$GLANCEIMAGENAME"`
echo "$ISIMAGEADDED"
if [[ -z "$ISIMAGEADDED" ]]
then
        echo "image noch nicht geaddet"
        glance image-create --name "$GLANCEIMAGENAME" --disk-format=raw --container-format=bare --file "$DOWNLOADFOLDER"/"$IMAGENAME"
        glance index
else
        echo "image bereits geaddet"
fi

#Erstelle Keypair und füge dieses zu einer VM hinzu
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
nova keypair-add --pub_key ~/.ssh/id_rsa.pub "$KEYPAIRNAME"
chmod 400 "$KEYPAIRNAME"

#Option für Automatische Floating-IP-Zuweisung der Nova-Konfigurationsdatei hinzufügen
echo "auto_assign_floating_ip = True" >> /etc/nova/nova.conf

#Erstellen einer VM mit dem hinzugefügtem Ubuntu Cloud Image
nova boot --image "$GLANCEIMAGENAME" --flavor 1 --key-name "$KEYPAIRNAME" vm_01


#comming soon:
#last command@ 3.4: log into vm with ssh
#http://docs.openstack.org/grizzly/basic-install/apt/content/basic-install_operate.html
#Füge für Nutzer ubuntu oder root ein passwort hinzu oder Lege neuen Nutzer an
#
#LOGIN="compute"
#IP="192.168.128.131"
# 
#ssh "$LOGIN"@"$IP" 'touch /tmp/testSuccess'  //test do something on ssh-server
#
