//final calculations!! circle diameter is 5.75 inches
//sooo the arms fully extended are 2.875 (2 7/8th) inches long
//with the two parts being 1.4375 (1 7/16th) inches long each
float MAX_OFFSET = 2.875 / 24;
float R = MAX_OFFSET * WINDOW_WIDTH;
float HALF_R = R / 2;
float HALF_R_SQ = HALF_R * HALF_R;

class KinectPixel {
  float x;
  float y;
  
  KinectPixel(float nx, float ny) {
    x = nx;
    y = ny;
  }
}

class Star {
  float SPRING_SPEED = WINDOW_WIDTH / 2.5;
  static final int radius = 20;

  float xIntent;
  float baseX;
  float baseY;
  float xOffset = 0;
  float yOffset = 0;

  float vX = 0;
  float vY = 0;
  
  int[] rotations = {0, 0};

  // Add velocities

  boolean isColliding = false;
  
  ArrayList<KinectPixel> kinectPixels = new ArrayList<KinectPixel>();

  Star(int col, int row, float xArtisticIntent) {
    baseX = WINDOW_WIDTH / 4 * (col + 0.5);
    baseY = WINDOW_HEIGHT / 6 * (row + 0.5);
    xIntent = xArtisticIntent;
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
    
    float baseAngle = (atan2(yOffset, xOffset) + PI) / PI * 180;
    baseAngle = 360 - ((baseAngle + 90) % 360); // adjust it
    // c
    float offsetMag = sqrt(xOffset * xOffset + yOffset * yOffset);
    
    int servoAngle = round(offsetMag / R * 130);
    float theta = acos(offsetMag / R) / PI * 180;
    int stepperAngle = round(baseAngle + theta) % 360;
    
    // Debug Draw
    textSize(50);
    fill(20, 100, 200);
    text(stepperAngle, baseX, baseY);
 
    // convert to degrees and store
    rotations[0] = stepperAngle;
    rotations[1] = servoAngle;
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
      //setPosition(pushX, pushY);
    }
  }
  
  void checkKinectPixel(int x, int y) {
    float dx = baseX - x;
    float dy = baseY - y;
    float distSq = (dx * dx) + (dy * dy);

    if (R * R > distSq) {
       kinectPixels.add(new KinectPixel(dx, dy));
    }
  }

  void update() {
    //if (!isColliding) {
    //  if (xOffset > 1 || xOffset < -1) xOffset -= xOffset / WINDOW_WIDTH * MAX_OFFSET * SPRING_SPEED;
    //  if (yOffset > 1 || yOffset < -1) yOffset -= yOffset / WINDOW_WIDTH * MAX_OFFSET * SPRING_SPEED;
    //}

    if (kinectPixels.size() > 0) {
      int mass = kinectPixels.size();
      float xAvg = 0;
      float yAvg = 0;
      
      for (int i = 0; i < kinectPixels.size(); i++) {
        xAvg += kinectPixels.get(i).x;
        yAvg += kinectPixels.get(i).y;
      }
      
      xAvg = xAvg / mass;
      yAvg = yAvg / mass;
      
      kinectPixels.clear();
      
      float mag = sqrt((xAvg * xAvg) + (yAvg * yAvg));
      float xMag = xAvg / mag;
      float yMag = yAvg / mag;
      
      mag = mag >= R ? R : mag;
      float distRatio = 1 - mag / R;
      
      //text(round(xAvg) + " : " + round(yAvg), baseX, baseY);
      xOffset = xMag * mass / 2 * distRatio;
      yOffset = yMag * mass / 2 * distRatio;
      

      // handle for if its avg is center here
      if (mass > 300) {
        xOffset = xIntent * (R - 10);
        yOffset = 1;
      }
      
    } else {
      xOffset = 0;
      yOffset = 0;
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
