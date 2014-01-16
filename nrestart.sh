for i in nova-novncproxy nova-api nova-cert nova-conductor nova-consoleauth nova-scheduler nova-network nova-api-metadata nova-compute
do
sudo service "$i" restart
done
