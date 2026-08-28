#include "command_handler.h"
#include "../storage/fram_store.h"
#include <Arduino.h>
#include <ArduinoJson.h>

static char    _buf[128];
static uint8_t _buf_len = 0;

void command_handler_init() {}

static void dispatch(const char* json_str) {
    JsonDocument doc;
    if (deserializeJson(doc, json_str) != DeserializationError::Ok) return;
    if (!doc["cmd"].is<const char*>()) return;
    if (strcmp(doc["cmd"], "reset") != 0) return;
    if (!doc["counter"].is<const char*>()) return;

    const char* counter = doc["counter"];
    if      (strcmp(counter, "trip")    == 0) fram_reset_trip();
    else if (strcmp(counter, "eng_oil") == 0) fram_reset_eng_oil();
    else if (strcmp(counter, "trans")   == 0) fram_reset_trans();
    else if (strcmp(counter, "diff")    == 0) fram_reset_diff();
    else if (strcmp(counter, "coolant") == 0) fram_reset_coolant();
    // "odo" is intentionally not handled — odometer cannot be reset
}

void command_handler_update() {
    while (Serial.available()) {
        char c = (char)Serial.read();
        if (c == '\n') {
            _buf[_buf_len] = '\0';
            if (_buf_len > 0) dispatch(_buf);
            _buf_len = 0;
        } else if (_buf_len < sizeof(_buf) - 1) {
            _buf[_buf_len++] = c;
        }
    }
}
