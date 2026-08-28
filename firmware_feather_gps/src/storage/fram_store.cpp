#include "fram_store.h"
#include "../config.h"
#include <Adafruit_FRAM_I2C.h>

static Adafruit_FRAM_I2C _fram;
static bool _fram_ok = false;

// RAM shadow — written to FRAM every FRAM_FLUSH_INTERVAL_MS
static double _odo      = 0.0;
static double _trip     = 0.0;
static double _eng_oil  = 0.0;
static double _trans    = 0.0;
static double _diff     = 0.0;
static double _coolant  = 0.0;

// ------------------------------------------------------------------
// Low-level FRAM I/O helpers
// ------------------------------------------------------------------

static void _write_u32(uint16_t addr, uint32_t v) {
    uint8_t* p = (uint8_t*)&v;
    for (int i = 0; i < 4; i++) _fram.write8(addr + i, p[i]);
}

static uint32_t _read_u32(uint16_t addr) {
    uint32_t v;
    uint8_t* p = (uint8_t*)&v;
    for (int i = 0; i < 4; i++) p[i] = _fram.read8(addr + i);
    return v;
}

static void _write_double(uint16_t addr, double v) {
    uint8_t* p = (uint8_t*)&v;
    for (int i = 0; i < 8; i++) _fram.write8(addr + i, p[i]);
}

static double _read_double(uint16_t addr) {
    double v;
    uint8_t* p = (uint8_t*)&v;
    for (int i = 0; i < 8; i++) p[i] = _fram.read8(addr + i);
    return v;
}

// ------------------------------------------------------------------
// Public API
// ------------------------------------------------------------------

bool fram_init() {
    _fram_ok = _fram.begin();   // uses default MB85RC I2C address 0x50
    if (!_fram_ok) return false;

    if (_read_u32(FRAM_ADDR_MAGIC) == FRAM_MAGIC) {
        _odo     = _read_double(FRAM_ADDR_ODO);
        _trip    = _read_double(FRAM_ADDR_TRIP);
        _eng_oil = _read_double(FRAM_ADDR_ENG_OIL);
        _trans   = _read_double(FRAM_ADDR_TRANS);
        _diff    = _read_double(FRAM_ADDR_DIFF);
        _coolant = _read_double(FRAM_ADDR_COOLANT);
    } else {
        // First boot or corrupt chip — zero everything and stamp the magic
        _odo = _trip = _eng_oil = _trans = _diff = _coolant = 0.0;
        fram_flush();
        _write_u32(FRAM_ADDR_MAGIC, FRAM_MAGIC);
    }
    return true;
}

double fram_get_odometer() { return _odo; }
double fram_get_trip()     { return _trip; }
double fram_get_eng_oil()  { return _eng_oil; }
double fram_get_trans()    { return _trans; }
double fram_get_diff()     { return _diff; }
double fram_get_coolant()  { return _coolant; }

void fram_add_distance(double miles) {
    if (miles <= 0.0) return;
    _odo     += miles;
    _trip    += miles;
    _eng_oil += miles;
    _trans   += miles;
    _diff    += miles;
    _coolant += miles;
}

void fram_reset_trip()    { _trip    = 0.0; if (_fram_ok) _write_double(FRAM_ADDR_TRIP,    _trip); }
void fram_reset_eng_oil() { _eng_oil = 0.0; if (_fram_ok) _write_double(FRAM_ADDR_ENG_OIL, _eng_oil); }
void fram_reset_trans()   { _trans   = 0.0; if (_fram_ok) _write_double(FRAM_ADDR_TRANS,   _trans); }
void fram_reset_diff()    { _diff    = 0.0; if (_fram_ok) _write_double(FRAM_ADDR_DIFF,    _diff); }
void fram_reset_coolant() { _coolant = 0.0; if (_fram_ok) _write_double(FRAM_ADDR_COOLANT, _coolant); }

void fram_flush() {
    if (!_fram_ok) return;
    _write_double(FRAM_ADDR_ODO,     _odo);
    _write_double(FRAM_ADDR_TRIP,    _trip);
    _write_double(FRAM_ADDR_ENG_OIL, _eng_oil);
    _write_double(FRAM_ADDR_TRANS,   _trans);
    _write_double(FRAM_ADDR_DIFF,    _diff);
    _write_double(FRAM_ADDR_COOLANT, _coolant);
}
