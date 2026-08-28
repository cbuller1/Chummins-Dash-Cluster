#pragma once

// ================================================================
// Adafruit Feather M4 Express — GPS speed & mileage node
// Adafruit Ultimate GPS FeatherWing on Serial1
// MB85RC256V FRAM on I2C (addr 0x50)
// ================================================================

// -- GPS (Ultimate GPS FeatherWing, UART) -----------------------
// Boot at 9600, then upgrade to GPS_BAUD_FAST for 10 Hz NMEA output.
#define GPS_BAUD             9600
#define GPS_BAUD_FAST        57600

// -- FRAM (MB85RC256V) ------------------------------------------
// 0xC0DE6B70 = "CODE 6BT" — used to validate a live data block
#define FRAM_MAGIC           0xC0DE6B70UL

// FRAM address map (bytes)
#define FRAM_ADDR_MAGIC      0x0000   // uint32_t  4 bytes
#define FRAM_ADDR_ODO        0x0004   // double    8 bytes — never reset
#define FRAM_ADDR_TRIP       0x000C   // double    8 bytes
#define FRAM_ADDR_ENG_OIL    0x0014   // double    8 bytes
#define FRAM_ADDR_TRANS      0x001C   // double    8 bytes
#define FRAM_ADDR_DIFF       0x0024   // double    8 bytes
#define FRAM_ADDR_COOLANT    0x002C   // double    8 bytes

// -- Serial (USB CDC to Raspberry Pi) ---------------------------
#define SERIAL_BAUD          115200
#define PUBLISH_INTERVAL_MS  100      // 10 Hz — matches gauge animation window (180 ms)
#define FRAM_FLUSH_INTERVAL_MS 10000  // flush counters to FRAM every 10 s
