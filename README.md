# Mosquitto install with Docker-Compose

## 1 - Install Docker. 
      See: https://docs.docker.com/install/
## 2 - Install Docker-Compose. 
      See: https://docs.docker.com/compose/install/
## 3 - Clone this repository
## 4 - Broker Authentication
       Edit mqtt.env file with broker authentication settings
## 5 - Running 
     $ docker-compose up --build
## 6 - Running with Bridge MQTT options
     #For bridge a external mqtt broker like cloudmqtt.com, edit mqtt_bridge.env with external broker parameters then:
     #!!!!This use a SSL connection configurarion whit the Bridge Server, and you need providing a ca-certificates file path like on .env file
     $ docker-compose -f docker-compose.yaml -f docker-compose-bridgemqtt.yaml up --build
     
