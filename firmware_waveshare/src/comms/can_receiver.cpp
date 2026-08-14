// CAN message 0x100 frame layout (8 bytes, big-endian):
//   [0–1]  TPS    uint16  tenths of percent  (0–1000 = 0.0–100.0 %)
//   [2–3]  Boost  int16   tenths of psi      (negative = vacuum)
//   [4]    Range  uint8   0=2hi 1=4hi 2=4lo 3=n
//   [5–7]  reserved
#include "can_receiver.h"
#include "../config.h"
#include <Arduino.h>
#include "driver/twai.h"

static float       _tps   = 0.0f;
static float       _boost = 0.0f;
static const char* _range = "2hi";

void can_receiver_init() {
    twai_general_config_t g = TWAI_GENERAL_CONFIG_DEFAULT(
        (gpio_num_t)PIN_CAN_TX, (gpio_num_t)PIN_CAN_RX, TWAI_MODE_NORMAL
    );
    twai_timing_config_t t = TWAI_TIMING_CONFIG_500KBITS();
    twai_filter_config_t f = TWAI_FILTER_CONFIG_ACCEPT_ALL();
    twai_driver_install(&g, &t, &f);
    twai_start();
}

static const char* range_from_byte(uint8_t r) {
    switch (r) {
        case 1:  return "4hi";
        case 2:  return "4lo";
        case 3:  return "n";
        default: return "2hi";
    }
}

void can_receiver_update() {
    twai_message_t msg;
    while (twai_receive(&msg, 0) == ESP_OK) {
        if (msg.identifier != CAN_MSG_SENSORS || msg.data_length_code < 5) continue;
        uint16_t tps_raw   = ((uint16_t)msg.data[0] << 8) | msg.data[1];
        int16_t  boost_raw = (int16_t)(((uint16_t)msg.data[2] << 8) | msg.data[3]);
        _tps   = tps_raw   / 10.0f;
        _boost = boost_raw / 10.0f;
        _range = range_from_byte(msg.data[4]);
    }
}

float       can_get_tps()   { return _tps; }
float       can_get_boost() { return _boost; }
const char* can_get_range() { return _range; }
