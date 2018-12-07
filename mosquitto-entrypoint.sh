#!/bin/ash
set -e
mkdir /mosquitto/pwd/ && touch /mosquitto/pwd/passwordfile
echo "testando 123!!!" >> /mosquitto/pwd/passwordfile
echo "#testando mais uma vez" >> /mosquitto/config/mosquitto.conf
cat /mosquitto/config/mosquitto.conf
exec "$@"
