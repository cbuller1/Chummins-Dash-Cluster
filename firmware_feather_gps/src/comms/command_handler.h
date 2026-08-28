#pragma once

void command_handler_init();

// Call every loop() — reads incoming JSON commands from Serial.
// Incoming format (from Raspberry Pi):
//   {"cmd":"reset","counter":"trip"}
//   {"cmd":"reset","counter":"eng_oil"}
//   {"cmd":"reset","counter":"trans"}
//   {"cmd":"reset","counter":"diff"}
//   {"cmd":"reset","counter":"coolant"}
// "odo" is intentionally rejected.
void command_handler_update();
