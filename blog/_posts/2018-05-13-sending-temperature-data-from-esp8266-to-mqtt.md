---
title: Sending temperature data from an ESP8266 to MQTT
date: 2018-05-13T10:00:0+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - IoT
  - domotics
  - MQTT
description: Collect and send IoT data from an ESP8266 board over MQTT.
---

Following my previous article, I'll explain how to send the temperature data captured by a sensor connected to an ESP8266 to an MQTT server via WiFi, so it can be stored in an InfluxDB database, displayed as a graph, used on your [home assistant](https://www.home-assistant.io/) installation,...

<!--more-->

## Items

This project is very similar to my previous one, except it doesn't use any display :

* ESP8266 development board
* DS18B20 temperature sensors
* 4.7K resistor
* breadboard
* jumper wires

## Wiring

Just follow the wiring instructions from my previous project, without the LCD of course.

## Code

For this project, I'm using [PlatformIO](https://platformio.org/) on VSCode, instead of the Arduino IDE. PlatformIO has a much nicer interface, and offers a lot of tools and improvements over the Arduino IDE.

One of the advantages of PlatformIO is that you can put configuration variables in a separate file ```platformio.ini```, and directly use these variables in your code. For example, I put my WiFi and MQTT configuration as externalized variables :

```
build_flags = '-DWIFI_SSID="my_wifi_ssid"' '-DWIFI_PASS="my_wifi_password"' '-DMQTT_SERVER="my_mqtt_server_ip"' '-DMQTT_TOPIC="my_mqtt_server_topic"' '-DDEVICE_NAME="my_device_name"'
```

The data sent to the MQTT server is a JSON object, containing the device IP, its name, and the temperature value:

```json
{
  "d": "device_name",
  "ip": "192.168.1.1",
  "t": 20.5
}
```

You need 3 libraries for this project :

* [DallasTemperature](https://github.com/milesburton/Arduino-Temperature-Control-Library)
* [PubSubClient](https://github.com/knolleary/pubsubclient.git)
* ESP8266WiFi *(included in the ESP8266 framework on PlatformIO)*

In the ```setup```, we initialize the one-wire bus, the temperature sensor, and the LCD.

In the ```loop```, we get the temperature, and display it on the LCD if its value changed since the last loop.

```cpp
#include <Arduino.h>
#include <DallasTemperature.h>
#include <PubSubClient.h>
#include <ESP8266WiFi.h>

// WiFi config - WIFI_SSID and WIFI_PASS are passed as variable

// MQTT server - MQTT_SERVER and MQTT_TOPIC are passed as variable

// DEVICE_NAME is passed as variable
const String deviceName = DEVICE_NAME;

// Data wire is plugged into pin D3 on the ESP8266
#define ONE_WIRE_BUS D3

#define TEMP_SIZE 7

// Setup a oneWire instance to communicate with any OneWire devices
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature.
DallasTemperature DS18B20(&oneWire);

WiFiClient espClient;
PubSubClient client(MQTT_SERVER, 1883, espClient);

String localIP;

char temperatureCString[TEMP_SIZE];
char previousTemp[TEMP_SIZE] = "init";

void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(WIFI_SSID);

  WiFi.begin(WIFI_SSID, WIFI_PASS);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  localIP = WiFi.localIP().toString();
  Serial.println(localIP);
}

void setup() {

  Serial.begin(115200);

  setup_wifi();

  delay(2000);

  DS18B20.begin();
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    // If you want to use a username and password, change next line to
    //if (client.connect("ESP8266Client", mqtt_user, mqtt_password)) {
    if (client.connect("ESP8266Client")) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void getTemperature() {

  float tempC;
  do {
    DS18B20.requestTemperatures();
    tempC = round(DS18B20.getTempCByIndex(0) * 2.0) / 2.0;
    dtostrf(tempC, 3, 1, temperatureCString);
    if (tempC == (-127)) {
      delay(100);
    }
  } while (tempC == (-127.0));
}

void loop() {

  getTemperature();

  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  Serial.println(temperatureCString);

  if (strcmp(previousTemp,temperatureCString) != 0) {
    strncpy(previousTemp, temperatureCString, TEMP_SIZE);
  }

  String tempAsString = temperatureCString;
  String totalLine = "{\"d\":\"" + deviceName + "\", \"ip\":\"" + localIP + "\", \"t\":" + tempAsString + "}";
  Serial.println(totalLine.c_str());
  client.publish(MQTT_TOPIC, totalLine.c_str(), true);

  delay(30000);
}   
```
