#include "digital_io.h"
#include "../config.h"
#include "WS_DIN.h"
#include "WS_Dout.h"

// Disable the WS_DIN auto-mirror task (we drive DO independently)
extern bool Dout_Immediate_Enable;

// DIN_PIN_CH1 (GPIO4) is reserved for RPM; init only CH2–CH8 here.
static const uint8_t DI_INIT_CHANNELS[] = {
    DI_CH_LOCKUP, DI_CH_OVERDRIVE,
    DI_CH_BLINKER_L, DI_CH_BLINKER_R,
    DI_CH_SPARE_1, DI_CH_SPARE_2, DI_CH_IGNITION
};
static const uint8_t DI_GPIO_FOR_CH[] = { 0, 4, 5, 6, 7, 8, 9, 10, 11 }; // index = channel

void digital_io_init() {
    Dout_Immediate_Enable = false;
    I2C_Init();                          // Wire on SDA=GPIO42, SCL=GPIO41
    TCA9554PWR_Init(0x00, 0x00);         // all DO outputs, all LOW (relays off)
    for (uint8_t ch : DI_INIT_CHANNELS) {
        pinMode(DI_GPIO_FOR_CH[ch], INPUT_PULLUP);
    }
}

// Board optocouplers are open-collector: 12 V applied → GPIO LOW, open/0 V → GPIO HIGH.
// LU/OD (0 V = active): no inversion needed. Standard (12 V = active): invert.
bool di_read(uint8_t ch) {
    switch (ch) {
        case 1: return !DIN_Read_CH1();  // reserved (RPM)
        case 2: return  DIN_Read_CH2();  // DI_CH_LOCKUP    — 0 V = active
        case 3: return  DIN_Read_CH3();  // DI_CH_OVERDRIVE — 0 V = active
        case 4: return !DIN_Read_CH4();
        case 5: return !DIN_Read_CH5();
        case 6: return !DIN_Read_CH6();
        case 7: return !DIN_Read_CH7();
        case 8: return !DIN_Read_CH8();
        default: return false;
    }
}

void do_write(uint8_t ch, bool on) {
    Dout_CHx(ch, on);  // TCA9554 I2C expander
}
