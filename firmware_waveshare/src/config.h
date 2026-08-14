#pragma once

// ================================================================
// Waveshare ESP32-S3-POE-ETH-8DI-8DO — pin assignments
// Verify all pins against the board schematic before flashing:
// https://www.waveshare.com/wiki/ESP32-S3-POE-ETH-8DI-8DO
// ================================================================

// -- RPM sensor (pulse/frequency input) -------------------------
// Connect a hall-effect or magnetic pickup conditioned to 3.3 V.
// For alternator W-terminal: set PULSES_PER_REV to
//   (alternator_poles / 2) * pulley_ratio  (e.g. 3 * 2.5 = 7.5)
#define PIN_RPM_INPUT        4
#define RPM_PULSES_PER_REV   1      // 1 for direct crank sensor

// -- CAN bus (TWAI) — receives sensor data from Feather M4 ------
// GPIOs 1 & 2 freed up after removing local ADC inputs
#define PIN_CAN_TX           2
#define PIN_CAN_RX           1
#define CAN_MSG_SENSORS      0x100  // TPS | Boost | Range from Feather M4

// -- 8 Digital Inputs (optocoupler-isolated, active LOW) --------
// Waveshare DI inputs pull high when open; LOW = signal present
#define PIN_DI_LOCKUP        5
#define PIN_DI_OVERDRIVE     6
#define PIN_DI_BLINKER_L     7
#define PIN_DI_BLINKER_R     8
#define PIN_DI_SPARE_1       9
#define PIN_DI_SPARE_2       10
#define PIN_DI_SPARE_3       11
#define PIN_DI_SPARE_4       12

// -- 8 Digital Outputs (relay — open for future use) ------------
#define PIN_DO_1             13
#define PIN_DO_2             14
#define PIN_DO_3             15
#define PIN_DO_4             16
#define PIN_DO_5             17
#define PIN_DO_6             18
#define PIN_DO_7             19
#define PIN_DO_8             20

// -- Serial (USB CDC) -------------------------------------------
#define SERIAL_BAUD          115200
#define PUBLISH_INTERVAL_MS  50    // 20 Hz
