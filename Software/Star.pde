class Star {
  static final float MAX_OFFSET = 100;
  static final float SPRING_SPEED = 3;
  static final int radius = 30;

  float baseX;
  float baseY;
  float xOffset = 0;
  float yOffset = 0;

  float vX = 0;
  float vY = 0;

  // Add velocities

  boolean isColliding = false;

  Star(float x, float y) {
    baseX = x;
    baseY = y;
  }

  float getX() {
    return baseX + xOffset;
  }

  float getY() {
    return baseY + yOffset;
  }

  void setColliding(boolean isCol) {
    isColliding = isCol;
  }

  void setPosition(float newXOffset, float newYOffset) {
    xOffset += newXOffset;
    yOffset += newYOffset;
  }

  void checkCollision(int x, int y) {
    float dx = getX() - x;
    float dy = getY() - y;
    float distSq = (dx * dx) + (dy * dy);

    if (minPushDist > distSq) {
      // isColliding = true;
      float mag = sqrt(dx * dx + dy * dy);
      float pushX = dx / mag;
      float pushY = dy / mag;

      setPosition(pushX, pushY);
    }
  }

  void update() {
    if (!isColliding) {
      if (xOffset > 1 || xOffset < -1) xOffset -= xOffset / MAX_OFFSET * SPRING_SPEED;
      if (yOffset > 1 || yOffset < -1) yOffset -= yOffset / MAX_OFFSET * SPRING_SPEED;
    }
  }

  void draw() {
    pushMatrix();
    translate(baseX + xOffset, baseY + yOffset);
    noStroke();
    fill(255);
    circle(0, 0, radius * 2);
    popMatrix();

    pushMatrix();
    translate(baseX, baseY);
    stroke(255);
    noFill();
    circle(0, 0, MAX_OFFSET * 2);
    popMatrix();
  }
}
