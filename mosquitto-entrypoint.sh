#!/bin/ash
set -e
if ( [ -z "${MOSQUITTO_USERNAME}" ] || [ -z "${MOSQUITTO_PASSWORD}" ] ); then
    echo "MOSQUITTO_USERNAME or MOSQUITTO_PASSWORD not defined!"
  else
    echo "Setting Mosquitto passwordfile..."
    mkdir /mosquitto/pwd/ && touch /mosquitto/pwd/passwordfile 
    mosquitto_passwd -b /mosquitto/pwd/passwordfile $MOSQUITTO_USERNAME $MOSQUITTO_PASSWORD
    cat /mosquitto/pwd/passwordfile
    sed -i 's/#allow_anonymous true/allow_anonymous false/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#password_file/password_file \/mosquitto\/pwd\/passwordfile/g' /mosquitto/config/mosquitto.conf
fi

echo "Setting config file for mosquitto..."

sed -i 's/#log_dest stderr/log_dest stderr\nlog_dest stdout/g' /mosquitto/config/mosquitto.conf
sed -i 's/#log_type information/#log_type information\nlog_type all/g' /mosquitto/config/mosquitto.conf

sed -i 's/#persistence false/persistence true/g' /mosquitto/config/mosquitto.conf
sed -i 's/#persistence_location/persistence_location \/mosquitto\/data\//g' /mosquitto/config/mosquitto.conf

if ( [ -z "${EXTERNAL_MQTT_SERVER}" ] || [ -z "${EXTERNAL_MQTT_PORT}" ] || [ -z "${EXTERNAL_MQTT_USERNAME}" ] || [ -z "${EXTERNAL_MQTT_PASSWORD}" ]); then
    echo "EXTERNAL_MQTT_SERVER or EXTERNAL_MQTT_PORT or EXTERNAL_MQTT_USERNAME or EXTERNAL_MQTT_PASSWORD not defined!"
  else
    echo "Setting bridge config for mosquitto..."
    sed -i 's/#connection <name>/connection ExternalBroker/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#address <host>\[:<port>\] \[<host>\[:<port>\]\]/address '"$EXTERNAL_MQTT_SERVER"':'"$EXTERNAL_MQTT_PORT"'/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#topic <topic> \[\[\[out | in | both\] qos-level\] local-prefix remote-prefix\]/topic # both/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#bridge_protocol_version mqttv311/bridge_protocol_version mqttv311/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#cleansession false/cleansession true/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#keepalive_interval 60/keepalive_interval 300/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#local_clientid/local_clientid internalMosquitoMQTTBroker/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#start_type automatic/start_type automatic/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#remote_username/remote_username '"$EXTERNAL_MQTT_USERNAME"'/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#remote_password/remote_password '"$EXTERNAL_MQTT_PASSWORD"'/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#bridge_cafile/bridge_cafile \/etc\/ssl\/certs\/ca-certificates.crt/g' /mosquitto/config/mosquitto.conf
    sed -i 's/#bridge_insecure false/bridge_insecure false/g' /mosquitto/config/mosquitto.conf
fi

cat /mosquitto/config/mosquitto.conf
exec "$@"
