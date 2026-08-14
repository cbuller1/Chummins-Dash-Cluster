#pragma once
#include <stdbool.h>

struct DashState {
    float       rpm;
    float       tps;            // 0–100 %
    float       boost;          // psi
    bool        lockupActive;
    bool        overdriveActive;
    bool        blinkerLeft;
    bool        blinkerRight;
    int         gear;           // 0 = neutral, -1 = unknown
    const char* range;          // "2hi" | "4hi" | "4lo" | "n"
};

void serial_publish(const DashState& state);
