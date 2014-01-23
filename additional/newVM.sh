# Skript zum Erstellen einer VM
# Verwendung: Parameter(variables) ändern und schließend: ./newVM.sh

#variables - can be changed
DOWNLOAD_FOLDER="images"
GLANCE_IMAGE_NAME="ubuntu12.04LTS"
FLAVOR_ID="1"		# nova flavor-list zeigt alle Flavors/Eigenschaften der VM
KEY_PAIR_NAME="default_key"
VM_NAME="vm_02"

#Erstellen einer VM mit dem hinzugefügtem Ubuntu Cloud Image und erstellem Keypair
nova boot --image "$GLANCE_IMAGE_NAME" --flavor "$FLAVOR_ID" --key-name "$KEY_PAIR_NAME" "$VM_NAME"
