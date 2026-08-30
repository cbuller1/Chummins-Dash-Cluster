#include "serial_protocol.h"
#include <Arduino.h>
#include <ArduinoJson.h>

// Wire format (1 Hz, to Raspberry Pi):
//   {"speed":12.3,"odo":12345.6,"trip":123.4,"eng_oil":456.7,"trans":234.5,"diff":100.2,"coolant":89.3}
void serial_publish(float speed_mph, double odo, double trip,
                    double eng_oil, double trans,
                    double diff,    double coolant) {
    JsonDocument doc;
    doc["speed"]   = speed_mph;
    doc["odo"]     = odo;
    doc["trip"]    = trip;
    doc["eng_oil"] = eng_oil;
    doc["trans"]   = trans;
    doc["diff"]    = diff;
    doc["coolant"] = coolant;

    serializeJson(doc, Serial);
    Serial.print('\n');
}
