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
#define RPM_PULSES_PER_REV   4      // Universal tach adapter: 4 pulses per revolution

// -- CAN bus (TWAI) — receives sensor data from Feather M4 ------
#define PIN_CAN_TX           2   // matches WS_GPIO.h TXD2
#define PIN_CAN_RX           3   // matches WS_GPIO.h RXD2
#define CAN_MSG_SENSORS      0x100  // TPS | Boost | Range from Feather M4

// -- 8 Digital Inputs (optocoupler-isolated) ----------------------------
// WS_DIN library maps CH1=GPIO4 (reserved for RPM), CH2–CH8=GPIO5–11.
// Open-collector output: 12 V applied → GPIO LOW. Open/0 V → GPIO HIGH.
// DI2 (LU) and DI3 (OD): 0 V = active — read directly (no inversion).
// All other DIs: 12 V = active — inverted in firmware..
//   board label → channel → GPIO
//   DI1           CH1       GPIO4   (RPM input — not used as DI)
//   DI2           CH2       GPIO5
//   DI3           CH3       GPIO6
//   DI4           CH4       GPIO7
//   DI5           CH5       GPIO8
//   DI6           CH6       GPIO9
//   DI7           CH7       GPIO10
//   DI8           CH8       GPIO11
#define DI_CH_LOCKUP        2   // DI2
#define DI_CH_OVERDRIVE     3   // DI3
#define DI_CH_BLINKER_L     4   // DI4
#define DI_CH_BLINKER_R     5   // DI5
#define DI_CH_SPARE_1       6   // DI6
#define DI_CH_SPARE_2       7   // DI7
#define DI_CH_IGNITION      8   // DI8 — ignition hot (active = key on)

// -- 8 Digital Outputs (relay, via TCA9554PWR I2C expander at 0x20) -
// Channel = board label DOn. Use do_write(ch, on) with channel numbers 1–8.
#define DO_CH_1             1   // DO1
#define DO_CH_2             2   // DO2
#define DO_CH_3             3   // DO3
#define DO_CH_4             4   // DO4
#define DO_CH_5             5   // DO5
#define DO_CH_6             6   // DO6
#define DO_CH_7             7   // DO7
#define DO_CH_8             8   // DO8

// -- Serial (USB CDC) -------------------------------------------
#define SERIAL_BAUD          115200
#define PUBLISH_INTERVAL_MS  50    // 20 Hz
