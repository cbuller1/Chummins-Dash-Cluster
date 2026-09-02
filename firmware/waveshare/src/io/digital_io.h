#pragma once
#include <stdint.h>
#include <stdbool.h>

void digital_io_init();
bool di_read(uint8_t ch);        // ch = DI channel 1–8; true = switch closed
void do_write(uint8_t ch, bool on); // ch = DO channel 1–8 (TCA9554 expander)
bool relay_outputs_enabled();
