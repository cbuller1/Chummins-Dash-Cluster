#include <Arduino.h>
#include "config.h"
#include "sensors/rpm.h"
#include "io/digital_io.h"
#include "comms/can_receiver.h"
#include "comms/command_handler.h"
#include "comms/serial_protocol.h"

static uint32_t lastPublish = 0;
static const uint32_t LOCKUP_OD_DEBOUNCE_MS = 300;

struct DebouncedInput {
    bool rawLast = false;
    bool stable = false;
    uint32_t changedAtMs = 0;
    bool initialized = false;
};

static DebouncedInput lockupDebounce;
static DebouncedInput overdriveDebounce;
static bool relayLockupLast = false;
static bool relayOverdriveLast = false;
static bool relayOutputsInitialized = false;

static bool update_debounced(DebouncedInput& d, bool rawNow, uint32_t nowMs, uint32_t debounceMs) {
    if (!d.initialized) {
        d.rawLast = rawNow;
        d.stable = rawNow;
        d.changedAtMs = nowMs;
        d.initialized = true;
        return d.stable;
    }

    if (rawNow != d.rawLast) {
        d.rawLast = rawNow;
        d.changedAtMs = nowMs;
    }

    if ((nowMs - d.changedAtMs) >= debounceMs) {
        d.stable = d.rawLast;
    }

    return d.stable;
}

void setup() {
    Serial.begin(SERIAL_BAUD);
    digital_io_init();  // I2C + TCA9554 init must precede rpm_init()
    rpm_init();         // reconfigures GPIO4 (DI CH1) as RPM interrupt input
    can_receiver_init();
    command_handler_init();
}

void loop() {
    rpm_update();
    can_receiver_update();
    command_handler_update();

    if (millis() - lastPublish < PUBLISH_INTERVAL_MS) return;
    uint32_t nowMs = millis();
    lastPublish = nowMs;

    bool lockupRaw = di_read(DI_CH_LOCKUP);
    bool overdriveRaw = di_read(DI_CH_OVERDRIVE);
    bool lockupActive = update_debounced(lockupDebounce, lockupRaw, nowMs, LOCKUP_OD_DEBOUNCE_MS);
    bool overdriveActive = update_debounced(overdriveDebounce, overdriveRaw, nowMs, LOCKUP_OD_DEBOUNCE_MS);

    DashState state;
    state.rpm             = rpm_get();
    state.tps             = can_get_tps();
    state.boost           = can_get_boost();
    state.lockupActive    = lockupActive;
    state.overdriveActive = overdriveActive;
    state.blinkerLeft     = di_read(DI_CH_BLINKER_L);
    state.blinkerRight    = di_read(DI_CH_BLINKER_R);
    state.ignitionOn      = di_read(DI_CH_IGNITION);
    state.gear            = -1;   // not wired; use a spare DI for neutral if needed
    state.range           = can_get_range();

    if (relay_outputs_enabled() && (!relayOutputsInitialized || relayLockupLast != state.lockupActive)) {
        do_write(DO_CH_1, state.lockupActive);    // DO1 mirrors lockup state
        relayLockupLast = state.lockupActive;
    }
    if (relay_outputs_enabled() && (!relayOutputsInitialized || relayOverdriveLast != state.overdriveActive)) {
        do_write(DO_CH_2, state.overdriveActive); // DO2 mirrors overdrive state
        relayOverdriveLast = state.overdriveActive;
    }
    relayOutputsInitialized = relay_outputs_enabled();

    serial_publish(state);
}
