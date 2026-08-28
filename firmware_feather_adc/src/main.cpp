#include <Arduino.h>
#include <CAN.h>
#include "config.h"

static const float ADC_MAX  = 4095.0f;
static const float ADC_VREF = 3.3f;

static uint32_t lastPublish = 0;

static inline float adc_to_volts(int raw) {
    return raw * (ADC_VREF / ADC_MAX);
}

// Returns throttle position 0–100 %
static float read_tps() {
    float vpin    = adc_to_volts(analogRead(PIN_TPS_ADC));
    float vsensor = vpin / TPS_DIVIDER_RATIO;
    return constrain(vsensor / TPS_V_FULL * 100.0f, 0.0f, 100.0f);
}

// Returns boost pressure in psi
static float read_boost() {
    float vpin    = adc_to_volts(analogRead(PIN_BOOST_ADC));
    float vsensor = vpin / BOOST_DIVIDER_RATIO;
    return constrain(vsensor / BOOST_V_FULL * BOOST_PSI_MAX, 0.0f, BOOST_PSI_MAX);
}

// Returns range byte: 0=2hi 1=4hi 2=4lo 3=n
static uint8_t read_range() {
    float vpin = adc_to_volts(analogRead(PIN_RANGE_ADC));
    if (vpin >= RANGE_N_V_MIN)   return 3;
    if (vpin >= RANGE_4LO_V_MIN) return 2;
    if (vpin >= RANGE_4HI_V_MIN) return 1;
    return 0;
}

void setup() {
    Serial.begin(115200);
    analogReadResolution(12);

    if (!CAN.begin(CAN_BAUD_BITS)) {
        Serial.println("CAN init failed");
        while (1) {}
    }
    Serial.println("Feather M4 CAN ready");
}

void loop() {
    if (millis() - lastPublish < PUBLISH_INTERVAL_MS) return;
    lastPublish = millis();

    float   tps   = read_tps();
    float   boost = read_boost();
    uint8_t range = read_range();

    // Pack into fixed-point integers to avoid float encoding over CAN
    uint16_t tps_raw   = (uint16_t)(tps   * 10.0f);  // tenths of percent
    int16_t  boost_raw = (int16_t) (boost * 10.0f);  // tenths of psi

    uint8_t frame[8] = {
        (uint8_t)(tps_raw   >> 8), (uint8_t)(tps_raw   & 0xFF),
        (uint8_t)(boost_raw >> 8), (uint8_t)(boost_raw & 0xFF),
        range, 0, 0, 0
    };

    CAN.beginPacket(CAN_MSG_SENSORS);
    CAN.write(frame, 8);
    CAN.endPacket();
}
