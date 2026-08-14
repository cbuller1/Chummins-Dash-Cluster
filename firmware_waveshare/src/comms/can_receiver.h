#pragma once

void        can_receiver_init();
void        can_receiver_update(); // drain receive queue; call every loop()
float       can_get_tps();         // 0–100 %
float       can_get_boost();       // psi
const char* can_get_range();       // "2hi" | "4hi" | "4lo" | "n"
