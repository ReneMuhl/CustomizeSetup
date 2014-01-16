if [[ -z "$1" ]]
then 
	echo "Benutzung: ./addUser IP_DER_VM"
else
	KEYPAIRNAME="default_key"
	VM_IP=$1

	ssh root@"$VM_IP" -i "$KEYPAIRNAME".pem 'useradd guest'
	echo "Passwort für den neuen Nutzer \"guest\" eingeben:"
	ssh root@"$VM_IP" -i "$KEYPAIRNAME".pem 'passwd guest'
	echo "jetzt kann sich in die VM mit dem Nutzer \"guest\" eingeloggt werden"
fi
