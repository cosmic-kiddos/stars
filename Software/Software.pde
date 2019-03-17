import processing.serial.*;

Serial stepperController;
Serial servoController;

// Configure ports setup here, base it off of the output from the console window
String stepperPort = "COM6";
String servoPort = "COM3";

// Update window size call as well because processing is lame
int WINDOW_WIDTH = 800;
int WINDOW_HEIGHT = 1200;

int numStars = 24;
Star[] stars = new Star[numStars];

float mousePush = 20;
float minPushDist = (Star.radius * Star.radius) + (mousePush * mousePush);
boolean shouldPush(Star s) {
  float distSq = (mouseX - s.getX()) * (mouseX - s.getX()) +
                 (mouseY - s.getY()) * (mouseY - s.getY());
  
  return (minPushDist > distSq);
}

void setup() {
  size(800, 1200);
  noStroke();
  background(0, 0, 0);
  
  // Uncomment this to enable kinect stuff
  //initKinect();
  
  
  println("PORTS");
  printArray(Serial.list());
  
  // Uncomment this to connect to steppers and servos, test the ports first
  //stepperController = new Serial(this, stepperPort, 9600);
  //servoController = new Serial(this, servoPort, 9600);
  
  // Generate stars, 24 of them to match array size
  for (int i = 0; i < numStars; i++) {
    int col = i % 4; // we have 4 columns
    int row = round(i / 4); // we have 6 rows
    stars[i] = new Star(col, row);
  }
}

void writeVal(Serial port, int val) {
  if (val < 100) port.write(0);
  if (val < 10) port.write(0);
  port.write(val);
}

void draw() {
  // set draw properties
  background(20);

  updateKinect();

  // If mouse within "r" of start 1 push it outward?
  for (int i = 0; i < numStars; i++) {
    stars[i].update();
    stars[i].draw();
  }
  for (int i = 0; i < numStars; i++) {
    stars[i].setColliding(shouldPush(stars[i]));
    
    if (stars[i].isColliding) {
      float dx = stars[i].getX() - mouseX;
      float dy = stars[i].getY() - mouseY;
      float mag = sqrt(dx * dx + dy * dy);

      float pushX = dx / mag;
      float pushY = dy / mag;

      stars[i].setPosition(pushX, pushY);
    }
  }

  pushMatrix();
  translate(mouseX, mouseY);
  noStroke();
  fill(255);
  circle(0, 0, 20);
  popMatrix();
  
  // Star Rotations
  print(stars[0].rotations[0]);
  print(" : ");
  println(stars[0].rotations[1]);
  
  // Serial message test
  //for (int i = 0; i < 5; i++) {
  //  // Uncomment these to write to arduino
  //  writeVal(stepperController, stars[i].rotations[0]);
  //  writeVal(servoController, stars[i].rotations[1]);
  //  if (i < 4) {
  //    stepperController.write(",");
  //    servoController.write(",");
  //  }
  //}
  //stepperController.write("-");
}
