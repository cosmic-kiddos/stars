/*
  Cosmic Kiddos Stepper Motor Control
  Five stepper motors are controlled.
  The motors should turn to the angle that is specified in the serial input
  Created 12 Mar. 2019
  by Cody Candler & Peter Gyory
*/

#include <Servo.h>

const int numberServos = 24; //change this depending on the number of stepper motors on this arduino
Servo servos[numberServos];

void setup() {
  pinMode(13, OUTPUT);
  // set the speed to 4 rpm:
  int speed = 10;

  for (int i = 0; i < numberServos; i++) {
    // servo pins go from 0 - 24
    servos[i].attach(i + 2);
  }

  // initialize the serial port:
  Serial.begin(9600);
}

String message = "";
void loop() {
  // If there is something in the buffer
  if (Serial.available() > 0) {
    message = Serial.readStringUntil('-');
    // 090, 000, 000, 000, 000-
    // val 1 0 - 3
    // val 2 4 - 7
    // val 3 8 - 11
    // val 4 12 - 15
    // val 5 16 - 19
    // message.substring(start, end).toInt() <----- Gets angle
    for (int i = 0; i < numberServos; i++) {
      float angle = message.substring(4 * i, 4 * i + 3).toFloat();
      int servoVal = (int) map(angle, 0, 180, 700, 2100);
      servos[i].writeMicroseconds(servoVal);
      //Serial.println(message.substring(4 * i, 4 * i + 3));
    }
  }

  delay(8);
}
