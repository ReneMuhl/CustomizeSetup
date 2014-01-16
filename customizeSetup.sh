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
nova keypair-add "$KEYPAIRNAME" > "$KEYPAIRNAME".pem
chmod 400 "$KEYPAIRNAME".pem

#Option für Automatische Floating-IP-Zuweisung der Nova-Konfigurationsdatei hinzufügen
echo "auto_assign_floating_ip = True" >> /etc/nova/nova.conf
for i in nova-novncproxy nova-api nova-cert nova-conductor nova-consoleauth nova-scheduler nova-network nova-api-metadata nova-compute
do
sudo service "$i" restart
done

#Erstellen einer VM mit dem hinzugefügtem Ubuntu Cloud Image
nova boot --image "$GLANCEIMAGENAME" --flavor 1 --key-name "$KEYPAIRNAME" vm_01
sleep 30

ssh root@192.168.128.250 -i "$KEYPAIRNAME".pem 'useradd guest'
echo "Passwort für den Nutzer \" guest \" eingeben:"
ssh root@192.168.128.250 -i "$KEYPAIRNAME".pem 'passwd guest'

