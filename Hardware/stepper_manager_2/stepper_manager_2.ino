/*
  Cosmic Kiddos Stepper Motor Control
  Five stepper motors are controlled.
  The motors should turn to the angle that is specified in the serial input
  Created 12 Mar. 2019
  by Cody Candler & Peter Gyory
*/

#include <Stepper.h>

const int numberSteppers = 12; //change this depending on the number of stepper motors on this arduino

const int stepsPerRevolution = 2048;  // change this to fit the number of steps per revolution. The number can be used to calibrate for drift
// for your motor

// initialize the steppers on the specified pins:
// Note. Some stepper controllers swap the middle two pins as is the case in this setup.
// Ex. Some kits would use 2,3,4,5 for stepper0
Stepper stepper0(stepsPerRevolution, 2, 4, 3, 5);
Stepper stepper1(stepsPerRevolution, 6, 8, 7, 9);
//Stepper stepper2(stepsPerRevolution, 10, 12, 11, 13);
Stepper stepper2(stepsPerRevolution, 14, 16, 15, 17);
Stepper stepper3(stepsPerRevolution, 18, 20, 19, 21);

Stepper stepper4(stepsPerRevolution, 22, 26, 24, 28);
Stepper stepper5(stepsPerRevolution, 23, 27, 25, 29);
Stepper stepper6(stepsPerRevolution, 30, 34, 32, 36);
Stepper stepper7(stepsPerRevolution, 31, 35, 33, 37);
Stepper stepper8(stepsPerRevolution, 38, 42, 40, 44);
Stepper stepper9(stepsPerRevolution, 39, 43, 41, 45);
Stepper stepper10(stepsPerRevolution, 46, 50, 48, 52);
Stepper stepper11(stepsPerRevolution, 47, 51, 49, 53);

//build an array of all the stepper motors
Stepper stepperArray[] = {
  stepper0, stepper1, stepper2, stepper3,
  stepper4, stepper5, stepper6, stepper7,
  stepper8, stepper9, stepper10, stepper11
};

int currentSteps[] = {0, 0, 0, 0, 0}; //track the current steps for each stepper
int desiredSteps[] = {0, 0, 0, 0, 0}; //the steps required to put the stepper to the desired angle

void setup() {
  pinMode(13, OUTPUT);
  // set the speed to 4 rpm:
  int speed = 10;

  stepper0.setSpeed(speed);
  stepper1.setSpeed(speed);
  stepper2.setSpeed(speed);
  stepper3.setSpeed(speed);
  stepper4.setSpeed(speed);

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
    for (int i = 0; i < numberSteppers; i++) {
      int angle = message.substring(4 * i, 4 * i + 3).toInt();
      desiredSteps[i] = angle * stepsPerRevolution / 360;
      //Serial.println(message.substring(4 * i, 4 * i + 3));
    }
  }

  for (int i = 0; i <= numberSteppers; i++) {
    if (currentSteps[i] < desiredSteps[i]) {
      stepperArray[i].step(1); //Step once forward
      currentSteps[i] += 1; //Remember/track this step
    } else if (currentSteps[i] > desiredSteps[i]) {
      stepperArray[i].step(-1); //Step once forward
      currentSteps[i] -= 1; //Remember/track this step
    }
  }

  delay(8);
}
