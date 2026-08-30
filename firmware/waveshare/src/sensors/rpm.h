#pragma once
#include <stdint.h>

void  rpm_init();
void  rpm_update();   // call every loop(); samples on a fixed window
float rpm_get();
