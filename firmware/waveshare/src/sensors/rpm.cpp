#include "rpm.h"
#include "../config.h"
#include <Arduino.h>

static volatile uint32_t _lastAcceptedUs = 0;  // timestamp of last glitch-free edge
static volatile uint32_t _lastPeriodUs   = 0;  // interval between last two valid edges
static volatile uint32_t _pulseSeq       = 0;  // increments once per accepted pulse
static volatile uint8_t  _rejectStreak   = 0;  // consecutive halving-rejects since last accept

static float _filteredRpm = 0.0f;

// Integer-only; reject ringing/duplicate edges closer than the minimum interval.
static void IRAM_ATTR onPulse() {
    uint32_t now   = micros();
    uint32_t delta = now - _lastAcceptedUs;  // unsigned subtraction is rollover-safe
    if (delta < RPM_MIN_PULSE_INTERVAL_US) return;
    // A mid-cycle noise edge halves the measured interval and doubles the RPM reading;
    // real engine speed can't double between two consecutive pulses, so reject it once.
    // But if the "halved" interval repeats, the baseline itself is stale (e.g. post-stall) —
    // accept it so a bad baseline can't permanently lock RPM out.
    if (_lastPeriodUs > 0 && delta < (_lastPeriodUs / 2) && _rejectStreak < 2) {
        _rejectStreak++;
        return;
    }
    _rejectStreak   = 0;
    _lastPeriodUs   = delta;
    _lastAcceptedUs = now;
    _pulseSeq++;
}

void rpm_init() {
    pinMode(PIN_RPM_INPUT, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(PIN_RPM_INPUT), onPulse, RISING);
}

void rpm_update() {
    static uint32_t lastSeq = 0;
    static bool     seeded  = false;

    noInterrupts();
    uint32_t seq            = _pulseSeq;
    uint32_t periodUs       = _lastPeriodUs;
    uint32_t lastAcceptedUs = _lastAcceptedUs;
    interrupts();

    // Engine stopped: clean fall to 0 and force re-seed on next start.
    if ((micros() - lastAcceptedUs) > (RPM_TIMEOUT_MS * 1000UL)) {
        _filteredRpm = 0.0f;
        seeded = false;
        lastSeq = seq;
        // Stale baseline period would otherwise reject every real pulse after restart.
        noInterrupts();
        _lastPeriodUs = 0;
        _rejectStreak = 0;
        interrupts();
        return;
    }

    if (seq == lastSeq) return;  // no new pulse this iteration
    lastSeq = seq;

    float raw = 60000000.0f / ((float)periodUs * (float)RPM_PULSES_PER_REV);
    if (raw > (float)RPM_MAX_REASONABLE) return;  // corrupt interval; keep last value

    if (!seeded) {
        _filteredRpm = raw;
        seeded = true;
    } else {
        _filteredRpm = RPM_EMA_ALPHA * raw + (1.0f - RPM_EMA_ALPHA) * _filteredRpm;
    }
}

float rpm_get() {
    return _filteredRpm;
}
