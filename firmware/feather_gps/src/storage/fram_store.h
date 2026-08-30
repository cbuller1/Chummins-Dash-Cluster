#pragma once
#include <stdbool.h>

// Initialize FRAM; loads stored counters or zeros them on first boot.
// Returns false if the FRAM chip is not detected.
bool fram_init();

double fram_get_odometer();   // total lifetime miles — never reset
double fram_get_trip();
double fram_get_eng_oil();
double fram_get_trans();
double fram_get_diff();
double fram_get_coolant();

// Add miles to all counters (odometer + all resettable intervals).
void fram_add_distance(double miles);

// Per-counter resets — odometer intentionally omitted.
void fram_reset_trip();
void fram_reset_eng_oil();
void fram_reset_trans();
void fram_reset_diff();
void fram_reset_coolant();

// Persist the current RAM counters to FRAM.
void fram_flush();
