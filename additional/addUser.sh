# Skript zum Hinzufügen eines Nutzers auf Basis eines Keypairs
# Verwendung: ./addUser VM_IP
## Anmerkung: die IP der VM erhält man durch Eingabe des OpenStack-Befehls: "nova list"
## (zum Auflisten der aktuellen VMs)

if [[ -z "$1" ]]
then 
	echo "Verwendung: ./addUser VM_IP"
else
	KEYPAIRNAME="default_key"
	VM_IP=$1

	ssh root@"$VM_IP" -i "$KEYPAIRNAME".pem 'useradd guest'
	echo "Passwort für den neuen Nutzer \"guest\" eingeben:"
	ssh root@"$VM_IP" -i "$KEYPAIRNAME".pem 'passwd guest'
	echo "jetzt kann sich in die VM mit dem Nutzer \"guest\" eingeloggt werden"
fi
