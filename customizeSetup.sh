#! /bin/bash

#constants
IMAGE_URL="http://cloud-images.ubuntu.com/precise/20131212/"
DOWNLOADFOLDER="images"
IMAGENAME="precise-server-cloudimg-amd64-disk1.img"




echo "Image (~243MB)  wird jetzt gedownloadet"
wget -P"$DOWNLOADFOLDER" "$IMAGE_URL""$IMAGENAME"
echo "Image wurde downloadet und befindet sich jetzt im Ordner:" "$DOWNLOADFOLDER"

source ~/openstackrc-demo
glance image-create --name ubuntu12.04.3LTS --disk-format=raw --container-format=bare --file "$DOWNLOADFOLDER"/"$IMAGENAME"
glance index


#2do: get image by name in glance index and start nova boot with this image
