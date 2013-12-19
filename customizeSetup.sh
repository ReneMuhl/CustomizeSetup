#! /bin/bash

#constants
IMAGE_URL="http://cloud-images.ubuntu.com/precise/20131212/"
DOWNLOADFOLDER="images"
IMAGENAME="precise-server-cloudimg-amd64-disk1.img"

#variables
GLANCEIMAGENAME="ubuntu12.04.3LTS"


if [ -f "$DOWNLOADFOLDER"/"$IMAGENAME" ]
then
    	echo "Image existiert bereits"
else
	echo "Image (~243MB) wird jetzt gedownloadet"
	wget -P"$DOWNLOADFOLDER" "$IMAGE_URL""$IMAGENAME"
	echo "Image wurde downloadet und befindet sich jetzt im Ordner:" "$DOWNLOADFOLDER"
fi

source ~/openstackrc-demo

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

nova boot --image "$GLANCEIMAGENAME" --flavor 1 vm_01
