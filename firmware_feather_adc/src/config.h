#pragma once

// ================================================================
// Adafruit Feather M4 CAN Express — sensor input configuration
// All voltages are measured at the MCU pin (after voltage dividers).
// ================================================================

// -- Analog input pins ------------------------------------------
#define PIN_TPS_ADC     A0   // TPS:   0–5 V  → 10k/10k divider → 0–2.5 V at pin
#define PIN_RANGE_ADC   A1   // Range: 0–5 V  → 10k/10k divider → 0–2.5 V at pin
#define PIN_BOOST_ADC   A2   // Boost: 0–10 V → 10k/22k divider → 0–3.125 V at pin

// -- Voltage divider ratios (Vpin = Vsensor × ratio) ------------
#define TPS_DIVIDER_RATIO    0.5f      // 10k / (10k + 10k)
#define RANGE_DIVIDER_RATIO  0.5f      // 10k / (10k + 10k)
#define BOOST_DIVIDER_RATIO  0.3125f   // 10k / (10k + 22k)

// -- Sensor full-scale input voltages ---------------------------
#define TPS_V_FULL      5.0f    // sensor output at 100 % throttle
#define BOOST_V_FULL    10.0f   // sensor output at max pressure
#define BOOST_PSI_MAX   30.0f   // max pressure in psi

// -- Range selector voltage thresholds (at pin, after divider) --
// Adjust these to match the physical detents of your range lever.
//   2hi  : 0.000 V – RANGE_4HI_V_MIN
//   4hi  : RANGE_4HI_V_MIN – RANGE_4LO_V_MIN
//   4lo  : RANGE_4LO_V_MIN – RANGE_N_V_MIN
//   n    : RANGE_N_V_MIN+
#define RANGE_4HI_V_MIN  0.625f   // ~25 % of 2.5 V full-scale
#define RANGE_4LO_V_MIN  1.250f   // ~50 %
#define RANGE_N_V_MIN    1.875f   // ~75 %

// -- CAN --------------------------------------------------------
#define CAN_BAUD_BITS        500000  // must match ESP32 config
#define CAN_MSG_SENSORS      0x100   // must match ESP32 config
#define PUBLISH_INTERVAL_MS  20      // 50 Hz
