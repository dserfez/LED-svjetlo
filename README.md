# README

It begins with a 20W LED chip which needs appropriate power and cooling. For the power, there is a constant current power source with AC 220V input and DC 40+ V output. As for cooling,... old laptop heatsink and fan! Ok, great, but is it possible to run the fan only when necessary? Yes, if we can measure the heatsink temperature and control the fan. And what if we could monitor it (possibly remotely -internet)? ESP8266.

# mqtt broker

* Docker container

```
docker run -ti --rm -v $(pwd):/opt/mqtt --name mqtt -p 1883:1883 alpine:3.2 /bin/sh
apk add --update mosquitto
/usr/sbin/mosquitto -c /etc/mosquitto/*.conf
```

# BIll Of Material

## Lamp

* LED chip 20w
* Power module 20W

## Cooling

* Recycled Laptop CPU / GPU cooler (metal)
* Recycled Laptop CPU / GPU cooler (fan 5V)
* Step-down power regulator 40V to 5V

## Sensor / controller

* ESP8266
* DHT11 Temperature/Humidity sensor
* LED which will report status:
    * Off when everything is OK
    * Blink when not connected to Wifi (every 1/3s)
