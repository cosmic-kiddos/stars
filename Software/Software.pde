Star s1 = new Star(400, 200);

float mousePush = 20;
float minPushDist = (Star.radius * Star.radius) + (mousePush * mousePush);
boolean shouldPush(Star s) {
  float distSq = (mouseX - s.getX()) * (mouseX - s.getX()) +
                 (mouseY - s.getY()) * (mouseY - s.getY());
  
  return (minPushDist > distSq);
}

void setup() {
  size(800, 400);
  noStroke();
  background(0, 0, 0);

  // initKinect();
}

void draw() {
  // set draw properties
  background(20);

  updateKinect();

  // If mouse within "r" of start 1 push it outward?
  s1.update();
  s1.draw();
  s1.setColliding(shouldPush(s1));
  if (s1.isColliding) {
    println(":P");
    float dx = s1.getX() - mouseX;
    float dy = s1.getY() - mouseY;
    float mag = sqrt(dx * dx + dy * dy);

    float pushX = dx / mag;
    float pushY = dy / mag;

    s1.setPosition(pushX, pushY);
  }

  pushMatrix();
  translate(mouseX, mouseY);
  noStroke();
  fill(255);
  circle(0, 0, 20);
  popMatrix();
}
