// Incoming command format (newline-delimited JSON from RPi):
//   {"cmd":"relay","i":<0-7>,"v":<true|false>}
#include "command_handler.h"
#include "../io/digital_io.h"
#include "../config.h"
#include <Arduino.h>
#include <ArduinoJson.h>

static const int DO_PIN_MAP[] = {
    PIN_DO_1, PIN_DO_2, PIN_DO_3, PIN_DO_4,
    PIN_DO_5, PIN_DO_6, PIN_DO_7, PIN_DO_8
};

static char    _buf[128];
static uint8_t _buf_len = 0;

void command_handler_init() {}

static void dispatch(const char* json_str) {
    JsonDocument doc;
    if (deserializeJson(doc, json_str) != DeserializationError::Ok) return;
    if (!doc["cmd"].is<const char*>()) return;

    if (strcmp(doc["cmd"], "relay") == 0) {
        int  idx = doc["i"] | -1;
        bool val = doc["v"] | false;
        if (idx >= 0 && idx < 8) do_write(DO_PIN_MAP[idx], val);
    }
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
