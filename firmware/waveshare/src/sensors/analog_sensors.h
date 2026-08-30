#pragma once

void  analog_sensors_init();
float analog_get_tps();    // returns 0–100 %
float analog_get_boost();  // returns psi
