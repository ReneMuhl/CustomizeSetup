#! /bin/bash
# Das Skript dient der Anpassung der OpenStack-Umgebung nach einer vorangegangenen Installation 
# nach dieser Anleitung: https://github.com/jedipunkz/openstack_grizzly_install.
# Anschließend steht für neue VMs ein Ubuntu Server Image der aktuellen LTS-Version 12.04 zur Verfügung.
# Desweiteren kann man sich in eine VM mit dem Nutzer "guest" und Passwort "guest" einloggen.
# Das erfolgt über das OpenStack Dashboard unter folgender Adresse: http://HOST_IP/horizon/.
## Anmerkung: FLOATING_RANGE und HOST_IP beziehen sich auf die Parameter aus der setup.conf 
## des Grizzly-Installationsskriptes von oben.


#variables - can be changed
DOWNLOAD_FOLDER="images"
GLANCE_IMAGE_NAME="ubuntu12.04LTS"
KEY_PAIR_NAME="default_key"
VM_IP="192.168.128.249"		#FLOATING_RANGE +1

#constants - must stay
IMAGE_URL="http://cloud-images.ubuntu.com/precise/current/"
IMAGE_NAME="precise-server-cloudimg-amd64-disk1.img"


#Download des Ubuntu Cloud Image
if [ -f "$DOWNLOAD_FOLDER"/"$IMAGE_NAME" ]
then
        echo "Image existiert bereits"
else
        echo "Image (~243MB) wird jetzt gedownloadet"
        wget -P"$DOWNLOAD_FOLDER" "$IMAGE_URL""$IMAGE_NAME"
        echo "Image wurde downloadet und befindet sich jetzt im Ordner:" "$DOWNLOAD_FOLDER"
fi

#Laden der Umgebungsvariablen zur Authentifizierung
source ~/openstackrc-demo

#Hinzufügen des Images zum OpenStack Image-Service Glance
IS_IMAGE_ADDED=`glance index | awk '{print $2}' | grep -E "$GLANCE_IMAGE_NAME"`
echo "$IS_IMAGE_ADDED"
if [[ -z "$IS_IMAGE_ADDED" ]]
then
        echo "Image wird jetzt hinzugefügt"
        glance image-create --name "$GLANCE_IMAGE_NAME" --disk-format=raw --container-format=bare --file "$DOWNLOAD_FOLDER"/"$IMAGE_NAME"
        glance index
else
        echo "Image bereits hinzugefügt"
fi

#Erstelle Keypair und speichere dieses im aktuellen Verzeichnis
nova keypair-add "$KEY_PAIR_NAME" > "$KEY_PAIR_NAME".pem
chmod 400 "$KEY_PAIR_NAME".pem

#Option für automatische Floating-IP-Zuweisung der Konfigurationsdatei von Nova hinzufügen
echo "auto_assign_floating_ip = True" >> /etc/nova/nova.conf
echo "public_interface=eth1" >> /etc/nova/nova.conf
for i in nova-novncproxy nova-api nova-cert nova-conductor nova-consoleauth nova-scheduler nova-network nova-api-metadata nova-compute
do
sudo service "$i" restart
done

#Erstellen einer VM mit dem hinzugefügtem Ubuntu Cloud Image und erstellem Keypair
nova boot --image "$GLANCE_IMAGE_NAME" --flavor 1 --key-name "$KEY_PAIR_NAME" vm_01
sleep 30

#Anlegen eines Nutzers "guest"
echo "Passwort für den neuen Nutzer \"guest\" eingeben:"
ssh root@"$VM_IP" -i "$KEY_PAIR_NAME".pem 'useradd guest'
echo "Passwort für den Nutzer \" guest \" eingeben:"
ssh root@"$VM_IP" -i "$KEY_PAIR_NAME".pem 'passwd guest'
echo "jetzt kann sich in die VM mit dem Nutzer \"guest\" eingeloggt werden"
#Nutzer sudo-Rechte hinzufügen
ssh root@"$VM_IP" -i "$KEY_PAIR_NAME".pem 'echo "guest ALL=(ALL:ALL) ALL" >> /etc/sudoers'
