#include "digital_io.h"
#include "../config.h"
#include <Arduino.h>

static const int DI_PINS[] = {
    PIN_DI_LOCKUP, PIN_DI_OVERDRIVE,
    PIN_DI_BLINKER_L, PIN_DI_BLINKER_R,
    PIN_DI_SPARE_1, PIN_DI_SPARE_2, PIN_DI_SPARE_3, PIN_DI_SPARE_4
};

static const int DO_PINS[] = {
    PIN_DO_1, PIN_DO_2, PIN_DO_3, PIN_DO_4,
    PIN_DO_5, PIN_DO_6, PIN_DO_7, PIN_DO_8
};

void digital_io_init() {
    for (int pin : DI_PINS) {
        pinMode(pin, INPUT_PULLUP);
    }
    for (int pin : DO_PINS) {
        pinMode(pin, OUTPUT);
        digitalWrite(pin, LOW);
    }
}

// Waveshare optocoupler DI outputs are active-LOW: LOW = switch closed
bool di_read(int pin) {
    return digitalRead(pin) == LOW;
}

void do_write(int pin, bool on) {
    digitalWrite(pin, on ? HIGH : LOW);
}
