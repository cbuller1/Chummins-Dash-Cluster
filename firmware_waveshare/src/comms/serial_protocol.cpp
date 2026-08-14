#include "serial_protocol.h"
#include <Arduino.h>
#include <ArduinoJson.h>

void serial_publish(const DashState& state) {
    JsonDocument doc;
    doc["rpm"]     = state.rpm;
    doc["tps"]     = state.tps;
    doc["boost"]   = state.boost;
    doc["lockup"]  = state.lockupActive;
    doc["od"]      = state.overdriveActive;
    doc["blink_l"] = state.blinkerLeft;
    doc["blink_r"] = state.blinkerRight;
    doc["ign"]     = state.ignitionOn;
    doc["gear"]    = state.gear;
    doc["range"]   = state.range;

    serializeJson(doc, Serial);
    Serial.print('\n');
}
