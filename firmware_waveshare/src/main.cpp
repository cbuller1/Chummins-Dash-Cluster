#include <Arduino.h>
#include "config.h"
#include "sensors/rpm.h"
#include "io/digital_io.h"
#include "comms/can_receiver.h"
#include "comms/command_handler.h"
#include "comms/serial_protocol.h"

static uint32_t lastPublish = 0;

void setup() {
    Serial.begin(SERIAL_BAUD);
    rpm_init();
    digital_io_init();
    can_receiver_init();
    command_handler_init();
}

void loop() {
    rpm_update();
    can_receiver_update();
    command_handler_update();

    if (millis() - lastPublish < PUBLISH_INTERVAL_MS) return;
    lastPublish = millis();

    DashState state;
    state.rpm             = rpm_get();
    state.tps             = can_get_tps();
    state.boost           = can_get_boost();
    state.lockupActive    = di_read(PIN_DI_LOCKUP);
    state.overdriveActive = di_read(PIN_DI_OVERDRIVE);
    state.blinkerLeft     = di_read(PIN_DI_BLINKER_L);
    state.blinkerRight    = di_read(PIN_DI_BLINKER_R);
    state.ignitionOn      = di_read(PIN_DI_IGNITION);
    state.gear            = -1;   // not wired; use a spare DI for neutral if needed
    state.range           = can_get_range();

    serial_publish(state);
}
