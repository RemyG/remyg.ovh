---
title: ESP8266 Temperature Display
date: 2018-05-01T10:00:0+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - IoT
  - domotics
---

In this article, I'll explain how to make a temperature sensor and display, using an ESP8266 board, a DS18B20 temperature sensor and an I2C LCD display.

The WiFi capabilities of the ESP8266 are not required in this project, but I intent to send the temperature values to an MQTT instance in a future version.

## Items

* ESP8266 development board
* DS18B20 temperature sensors
* I2C LCD 16x2 display
* 4.7K resistor
* breadboard
* jumper wires

<!--more-->

## Wiring

The wiring for this project is quite simple.

* The DS18B20 sensor DATA pin is wired to the ESP8266 D3 pin.
* The LCD I2C SDA pin is wired to the ESP8266 D4 pin, and the SCL pin to the D5 pin.

![Wiring]({{ site.cdn_url }}/esp8266-ds18b20-wiring.png)

## Code

You need 3 libraries for this project :

* [OneWire](https://github.com/PaulStoffregen/OneWire)
* [DallasTemperature](https://github.com/milesburton/Arduino-Temperature-Control-Library)
* [LiquidCrystal_I2C](https://github.com/marcoschwartz/LiquidCrystal_I2C)

You can find the code on GitHub [here](https://github.com/RemyG/iot-temp-to-lcd).

In the ```setup```, we initialize the one-wire bus, the temperature sensor, and the LCD.

In the ```loop```, we get the temperature, and display it on the LCD if its value changed since the last loop.

```cpp
#include <LiquidCrystal_I2C.h>
#include <DallasTemperature.h>
#include <OneWire.h>

// Data wire is plugged into pin D3 on the ESP8266
#define ONE_WIRE_BUS D3

// LCD pins
#define SDA_PIN D4
#define SCL_PIN D5

#define TEMP_SIZE 7

// Setup a oneWire instance to communicate with any OneWire devices
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature.
DallasTemperature DS18B20(&oneWire);

char temperatureCString[TEMP_SIZE];
char previousTemp[TEMP_SIZE] = "init";

LiquidCrystal_I2C lcd(0x27, 16, 2); // The I2C address may be different in your project, see the notes below.

void setup() {

  Serial.begin(115200);

  Wire.begin(SDA_PIN, SCL_PIN);

  lcd.init();
  lcd.backlight();
  lcd.setCursor(5, 0);
  lcd.print("HELLO");
  lcd.setCursor(5, 1);
  lcd.print("WORLD");

  delay(2000);

  DS18B20.begin();

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Temp.:");
}

void getTemperature() {

  float tempC;
  do {
    DS18B20.requestTemperatures();
    tempC = DS18B20.getTempCByIndex(0);
    dtostrf(tempC, 3, 1, temperatureCString);
    if (tempC == (-127)) {
      delay(100);
    }
  } while (tempC == (-127.0));
}

void loop() {

  getTemperature();

  Serial.println(temperatureCString);

  if (strcmp(previousTemp,temperatureCString) != 0) {
    lcd.setCursor(7, 0);
    lcd.print(temperatureCString);
    strncpy(previousTemp, temperatureCString, TEMP_SIZE);
  }

  delay(2000);
}
```

## Notes

If nothing appears on the LCD, it could be due to several factors:

* the I2C board has a contrast adjustment potentiometer, which looks like a screw in a small blue cube on the back of the board.
* the I2C address used in the command ```LiquidCrystal_I2C lcd(0x27, 16, 2);``` (```0x27```) may be different for you, preventing anything to be displayed on the LCD. If it's the case, you can find several I2C address scanner projects to run on your board (eg. on [Instructables](http://www.instructables.com/id/ESP8266-I2C-PORT-and-Address-Scanner/)).
