/*
  Cosmic Kiddos Stepper Motor Control
  Five stepper motors are controlled.
  The motors should turn to the angle that is specified in the serial input
  Created 12 Mar. 2019
  by Cody Candler & Peter Gyory
*/

#include <Servo.h>

const int numberServos = 24; //change this depending on the number of stepper motors on this arduino
int stepSize = 5;
int servoPins[] = {
  30, 36, 38, 44,
  29, 35, 39, 45,
  28, 34, 40, 46,
  27, 33, 41, 47,
  26, 32, 42, 48,
  25, 31, 43, 49
};
Servo servos[numberServos];
int targetPositions[] = {
  700, 700, 700, 700,
  700, 700, 700, 700,
  700, 700, 700, 700,
  700, 700, 700, 700,
  700, 700, 700, 700,
  700, 700, 700, 700
};
int currentPositions[] = {
  700, 700, 700, 700,
  700, 700, 700, 700,
  700, 700, 700, 700,
  700, 700, 700, 700,
  700, 700, 700, 700,
  700, 700, 700, 700
};

void setup() {
  // set the speed to 4 rpm:
  int speed = 10;

  for (int i = 0; i < numberServos; i++) {
    // servo pins go from 0 - 24
    servos[i].attach(servoPins[i]);
  }

  // initialize the serial port:
  Serial.begin(9600);
}

String message = "";
void loop() {
  // If there is something in the buffer
  if (Serial.available() > 0) {
    message = Serial.readStringUntil('-');
    boolean goodMsg = message.endsWith(",");
    // 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,-
    // 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,-
    // 180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,-
    // val 1 0 - 3
    // val 2 4 - 7
    // val 3 8 - 11
    // val 4 12 - 15
    // val 5 16 - 19
    // message.substring(start, end).toInt() <----- Gets angle
    if (goodMsg) {
      for (int i = 0; i < numberServos; i++) {
        float angle = message.substring(4 * i, 4 * i + 3).toInt();
        int servoVal = (int) map(angle, 0, 180, 720, 2100);
        targetPositions[i] = servoVal;
//        servos[i].writeMicroseconds(servoVal);
      }
    }
  }

  for (int i = 0; i < numberServos; i++) {
    if (currentPositions[i] > targetPositions[i] + stepSize) {
      currentPositions[i] -= stepSize;
      servos[i].writeMicroseconds(currentPositions[i]);
    } else if (currentPositions[i] < targetPositions[i] - stepSize) {
      currentPositions[i] += stepSize;
      servos[i].writeMicroseconds(currentPositions[i]);
    }
//servos[i].writeMicroseconds(targetPositions[i]);
  }

  delay(8);
}
