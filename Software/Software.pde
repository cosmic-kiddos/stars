import processing.serial.*;

Serial stepperController1;
Serial stepperController2;
Serial servoController;

// Configure ports setup here, base it off of the output from the console window
String stepperPort1 = "COM8";
String stepperPort2 = "COM4";
String servoPort = "COM11";

// Update window size call as well because processing is lame
int WINDOW_WIDTH = 800;
int WINDOW_HEIGHT = 1200;

// Send update timer
int lastFrame = 0;
int SEND_UPDATE_MAX = 100;
int sendUpdateTimer = SEND_UPDATE_MAX;

boolean shouldSendZero = true;

boolean lastFrameSpaceDown = false;
boolean portsOpen = true;

int numStars = 24;
Star[] stars = new Star[numStars];

float mousePush = 30;
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
  initKinect();
  
  println("PORTS");
  printArray(Serial.list());
  
  // Uncomment this to connect to steppers and servos, test the ports first
  if (portsOpen) {
    stepperController1 = new Serial(this, stepperPort1, 9600);
    delay(1500);
    stepperController2 = new Serial(this, stepperPort2, 9600);
    delay(1500);
    servoController = new Serial(this, servoPort, 9600);
    delay(1000);
  }
  
  // Generate stars, 24 of them to match array size
  for (int i = 0; i < numStars; i++) {
    int col = i % 4; // we have 4 columns
    int row = round(i / 4); // we have 6 rows
    float xIntent = col > 1 ? 1 : -1;
    stars[i] = new Star(col, row, xIntent);
  }
}

String getWriteVal(int val) {
  String writeVal = "";
  if (val < 100) writeVal += "0";
  if (val < 10) writeVal += "0";
  writeVal += val;
  
  if (shouldSendZero) writeVal = "000";
  
  return writeVal;
}

void keyPressed() {
  if (key == ' ' && !lastFrameSpaceDown) {
    lastFrameSpaceDown = true;
    shouldSendZero = !shouldSendZero;
  }
}

void keyReleased() {
  if (key == ' ') {
    lastFrameSpaceDown = false;
  }
}

void draw() {
  // set draw properties
  background(20);
  
  // Get DeltaTime
  int currentFrame = millis();
  int dt = currentFrame - lastFrame;
  lastFrame = currentFrame;

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
  //print(stars[0].rotations[0]);
  //print(" : ");
  //println(stars[0].rotations[1]);
  
  String stepper1Val = "";
  String stepper2Val = "";
  String servoVal = "";
  // Serial message test
  for (int i = 0; i < 24; i++) {
    // Uncomment these to write to arduino
    if (i % 4 < 2) {
      stepper1Val += getWriteVal(stars[i].rotations[0]);
      stepper1Val += ",";
    }
    else {
      stepper2Val += getWriteVal(stars[i].rotations[0]);
      stepper2Val += ",";
    }

    servoVal += getWriteVal(stars[i].rotations[1]);
    servoVal += ",";
  }

  sendUpdateTimer += dt;
  if (sendUpdateTimer > SEND_UPDATE_MAX) {
    sendUpdateTimer = 0;
    if (portsOpen) {
      stepperController1.write(stepper1Val + "-");
      stepperController2.write(stepper2Val + "-");
      servoController.write(servoVal + "-");
    }
    // Debug Packet
    println(stepper1Val + "-");
    //println(stepper2Val + "-");
    println(servoVal + "-");
  }
}
