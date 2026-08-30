#pragma once

// Publish one JSON frame to USB CDC Serial.
// speed_mph — GPS speed over ground (0 if no fix)
void serial_publish(float speed_mph, double odo, double trip,
                    double eng_oil, double trans,
                    double diff,    double coolant);
