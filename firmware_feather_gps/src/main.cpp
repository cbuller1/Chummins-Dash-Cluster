#include <Arduino.h>
#include <Adafruit_GPS.h>
#include "config.h"
#include "storage/fram_store.h"
#include "comms/serial_protocol.h"
#include "comms/command_handler.h"

static Adafruit_GPS GPS(&Serial1);

static uint32_t _lastPublish = 0;
static uint32_t _lastFlush   = 0;
static uint32_t _lastAccum   = 0;

void setup() {
    Serial.begin(SERIAL_BAUD);

    if (!fram_init()) {
        Serial.println("{\"error\":\"FRAM not detected\"}");
        // Continue without persistence — counters will reset on power cycle
    }

    GPS.begin(GPS_BAUD);
    // Upgrade to faster baud so 10 Hz NMEA output fits within the UART budget.
    GPS.sendCommand(PMTK_SET_BAUD_57600);
    delay(100);
    Serial1.begin(GPS_BAUD_FAST);
    GPS.sendCommand(PMTK_SET_NMEA_OUTPUT_RMCONLY); // RMC has speed, position, fix status
    GPS.sendCommand(PMTK_SET_NMEA_UPDATE_10HZ);
    GPS.sendCommand(PMTK_API_SET_FIX_CTL_5HZ);    // MTK3339 fix calculation at 5 Hz

    command_handler_init();
    _lastAccum = millis();
}

void loop() {
    // Feed GPS parser character by character
    GPS.read();
    if (GPS.newNMEAreceived()) {
        GPS.parse(GPS.lastNMEA());
    }

    uint32_t now = millis();

    // Distance accumulation — elapsed-time based for accuracy across variable loop rates
    uint32_t accumElapsed = now - _lastAccum;
    if (accumElapsed >= 1000) {
        _lastAccum = now;
        if (GPS.fix) {
            double speed_mph = GPS.speed * 1.15078;   // knots to mph
            double miles     = speed_mph * (accumElapsed / 3600000.0);
            fram_add_distance(miles);
        }
    }

    // Periodic FRAM flush — at most once every FRAM_FLUSH_INTERVAL_MS
    if (now - _lastFlush >= FRAM_FLUSH_INTERVAL_MS) {
        _lastFlush = now;
        fram_flush();
    }

    // Publish to Raspberry Pi
    if (now - _lastPublish >= PUBLISH_INTERVAL_MS) {
        _lastPublish = now;
        float speed_mph = GPS.fix ? (float)(GPS.speed * 1.15078) : 0.0f;
        serial_publish(speed_mph,
                       fram_get_odometer(), fram_get_trip(),
                       fram_get_eng_oil(),  fram_get_trans(),
                       fram_get_diff(),     fram_get_coolant());
    }

    // Handle reset commands from Raspberry Pi
    command_handler_update();
}
