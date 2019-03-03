import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Software extends PApplet {

Star s1 = new Star(400, 200);

float mousePush = 20;
float minPushDist = (Star.radius * Star.radius) + (mousePush * mousePush);
public boolean shouldPush(Star s) {
  float distSq = (mouseX - s.getX()) * (mouseX - s.getX()) +
                 (mouseY - s.getY()) * (mouseY - s.getY());
  
  return (minPushDist > distSq);
}

public void setup() {
  
  noStroke();
  background(0, 0, 0);

  // initKinect();
}

public void draw() {
  background(20);

  // updateKinect();

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


SimpleOpenNI context;

public void initKinect() {
  context = new SimpleOpenNI(this);

  if (context.isInit() == false) {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  context.setMirror(false);
  context.enableDepth();
}

public void updateKinect() {
  context.update();

  // get depth grid
  int[] depthPoints = context.depthMap(); 
  int depthW = context.depthWidth();
  int depthH = context.depthHeight();
  int pixelSkip = 5;

  // configure active depth
  int kinectNear = 500;
  int kinectFar = 2500;
  int silhouetteNear = 1700;
  int silhouetteFar = 2000;
}
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

  public float getX() {
    return baseX + xOffset;
  }

  public float getY() {
    return baseY + yOffset;
  }

  public void setColliding(boolean isCol) {
    isColliding = isCol;
  }

  public void setPosition(float newXOffset, float newYOffset) {
    xOffset += newXOffset;
    yOffset += newYOffset;
  }

  public void update() {
    if (!isColliding) {
      if (xOffset > 1 || xOffset < -1) xOffset -= xOffset / MAX_OFFSET * SPRING_SPEED;
      if (yOffset > 1 || yOffset < -1) yOffset -= yOffset / MAX_OFFSET * SPRING_SPEED;
    }
  }

  public void draw() {
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
  public void settings() {  size(800, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Software" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
