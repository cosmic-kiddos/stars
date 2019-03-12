import processing.serial.*;

Serial stepperController;

// Configure ports setup here, base it off of the output from the console window
String stepperPort = "COM4";

// Update window size call as well because processing is lame
int WINDOW_WIDTH = 800;
int WINDOW_HEIGHT = 1200;

Star[] stars = new Star[24];

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
  
  stepperController = new Serial(this, stepperPort, 9600);
  
  // Generate stars, 24 of them to match array size
  for (int i = 0; i < 24; i++) {
    int col = i % 4; // we have 4 columns
    int row = round(i / 4); // we have 6 rows
    stars[i] = new Star(col, row);
  }
}

void draw() {
  // set draw properties
  background(20);

  updateKinect();

  // If mouse within "r" of start 1 push it outward?
  for (int i = 0; i < 24; i++) {
    stars[i].update();
    stars[i].draw();
  }
  // s1.setColliding(shouldPush(s1));
  // if (s1.isColliding) {
  //   println(":P");
  //   float dx = s1.getX() - mouseX;
  //   float dy = s1.getY() - mouseY;
  //   float mag = sqrt(dx * dx + dy * dy);

  //   float pushX = dx / mag;
  //   float pushY = dy / mag;

  //   s1.setPosition(pushX, pushY);
  // }

  pushMatrix();
  translate(mouseX, mouseY);
  noStroke();
  fill(255);
  circle(0, 0, 20);
  popMatrix();
  
  stepperController.write("0,0,0,0,0-");
  delay(1000);
  stepperController.write("90,0,0,0,0-");
  delay(1000);
  stepperController.write("120,0,0,0,0-");
  delay(1000);
  stepperController.write("80,0,0,0,0-");
  delay(1000);
}
