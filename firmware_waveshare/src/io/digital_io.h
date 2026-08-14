#pragma once
#include <stdbool.h>

void digital_io_init();
bool di_read(int pin);           // true = switch closed
void do_write(int pin, bool on);
