#include "rpm.h"
#include "../config.h"
#include <Arduino.h>

static volatile uint32_t _pulseCount = 0;
static float             _currentRpm = 0.0f;
static uint32_t          _lastSampleMs = 0;

static const uint32_t SAMPLE_WINDOW_MS = 100;

static void IRAM_ATTR onPulse() {
    _pulseCount++;
}

void rpm_init() {
    pinMode(PIN_RPM_INPUT, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(PIN_RPM_INPUT), onPulse, RISING);
    _lastSampleMs = millis();
}

void rpm_update() {
    uint32_t now = millis();
    if (now - _lastSampleMs < SAMPLE_WINDOW_MS) return;

    uint32_t elapsed = now - _lastSampleMs;
    _lastSampleMs = now;

    noInterrupts();
    uint32_t count = _pulseCount;
    _pulseCount = 0;
    interrupts();

    _currentRpm = (count * 60000.0f) / (RPM_PULSES_PER_REV * elapsed);
}

float rpm_get() {
    return _currentRpm;
}
