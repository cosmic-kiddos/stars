//final calculations!! circle diameter is 5.75 inches
//sooo the arms fully extended are 2.875 (2 7/8th) inches long
//with the two parts being 1.4375 (1 7/16th) inches long each
float MAX_OFFSET = 2.875 / 24;
float R = MAX_OFFSET * WINDOW_WIDTH;
float HALF_R = R / 2;
float HALF_R_SQ = HALF_R * HALF_R;

class Star {
  float SPRING_SPEED = WINDOW_WIDTH / 2.5;
  static final int radius = 20;

  float baseX;
  float baseY;
  float xOffset = 0;
  float yOffset = 0;

  float vX = 0;
  float vY = 0;
  
  int[] rotations = {0, 0};

  // Add velocities

  boolean isColliding = false;

  Star(int col, int row) {
    baseX = WINDOW_WIDTH / 4 * (col + 0.5);
    baseY = WINDOW_HEIGHT / 6 * (row + 0.5);
  }

  float getX() {
    return baseX + xOffset;
  }

  float getY() {
    return baseY + yOffset;
  }
  
  // c^2 = a^2 + b^2 - 2ab*cos(C); <- law of cosine
  void updateRotations() {
    if ((yOffset < 0.1 && yOffset > -0.1) || (xOffset < 0.1 && xOffset > -0.1)) {
      rotations[0] = 0;
      rotations[1] = 0;
      return; // hahaha bailing return statement
    }
    
    float baseAngle = atan2(yOffset, xOffset);
    // c
    float offsetMag = xOffset * xOffset + yOffset * yOffset;
    
    // this is the servo angle
    float c = acos(1 - (offsetMag / HALF_R_SQ / 2));
    float ab = (PI - c) / 2;
    
    float stepperAngle = baseAngle - ab;
    
    // convert to degrees and store
    rotations[0] = round(stepperAngle / PI * 180);
    rotations[1] = round(c / PI * 180);
    
    if (rotations[0] < 0) {
      rotations[0] = rotations[0] + 360;
    }
    
    if (rotations[1] < 0) {
      //rotations[1] = rotations[1] + 360;
    }
    
    rotations[0] = 360 - rotations[0];
  }

  void setColliding(boolean isCol) {
    isColliding = isCol;
  }

  void setPosition(float dxOffset, float dyOffset) {
    float newXOffset = xOffset + dxOffset;
    float newYOffset = yOffset + dyOffset;
    
    float offsetMag = sqrt(newXOffset * newXOffset + newYOffset * newYOffset);
    if (offsetMag < MAX_OFFSET * WINDOW_WIDTH) {
      xOffset = newXOffset;
      yOffset = newYOffset;
    }
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
      if (xOffset > 1 || xOffset < -1) xOffset -= xOffset / WINDOW_WIDTH * MAX_OFFSET * SPRING_SPEED;
      if (yOffset > 1 || yOffset < -1) yOffset -= yOffset / WINDOW_WIDTH * MAX_OFFSET * SPRING_SPEED;
    }
    
    updateRotations();
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
    circle(0, 0, WINDOW_WIDTH * MAX_OFFSET * 2);
    popMatrix();
  }
}
