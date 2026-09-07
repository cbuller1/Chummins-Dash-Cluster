#pragma once
#include <stdint.h>

void  rpm_init();
void  rpm_update();   // call every loop(); event-driven pulse-period measurement
float rpm_get();
