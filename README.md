(CustomizeSetup)

Anleitung zum Ausprobieren des OpenStack Frameworks (Version Grizzly)
======================================================================================

Überblick:
----------
Zum Testen von OpenStack wird eine Installation mit nova-network auf einem Rechner empfohlen (All in One Node).
Benötigt wird ein Rechner mit Internetzugang und zwei Netzwerkkarten(NIC), auf dem
ein Debian-basiertes Betriebssystem installiert ist (bspw. Ubuntu).
Alle OpenStack Befehle gehen nur, wenn man entsprechende Umgebungsvariablen mit:
`source ~/openstackrc-demo` geladen hat.

Ablauf:
----------
1. Installation von git und kopieren des Installationsskriptes mit:
`git clone https://github.com/jedipunkz/openstack_grizzly_install.git`
2. Netzwerkkonfiguration (/etc/network/interfaces) anpassen, anhand der Anleitung auf:
https://github.com/jedipunkz/openstack_grizzly_install
(Bsp.: in Datei: interfaces.example)
3. Anpassung der Installtionsparameter in der Datei:
"openstack_grizzly_install/setup.conf"
(Bsp.: in Datei: setup.conf.example)
4. Starten des Skriptes:
`sudo ./setup.sh allinone`
5. "customizeSetup.sh" auf den Rechner kopieren, Ausführungsrechte geben und ausführen
6. Login in das OpenStack Dashboard unter http://HOST_IP/horizon/
mit folgenden Daten:
login:demo pwd:demo

