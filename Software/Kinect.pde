import SimpleOpenNI.*;

SimpleOpenNI context;

boolean kinectInitialized = false;

void initKinect() {
  context = new SimpleOpenNI(this);

  if (context.isInit() == false) {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  context.setMirror(false);
  context.enableDepth();
  
  kinectInitialized = true;
}

void updateKinect() {
  if (kinectInitialized) {
    context.update();
  
    // get depth grid
    int[] depthPoints = context.depthMap();
    // 320, 480
    int depthW = context.depthWidth();
    int depthH = context.depthHeight();
    int pixelSkip = 8;
    
    int scale = WINDOW_HEIGHT / 480;
    
    int xMin = 160;
    int xMax = 480;
    int xRange = xMax - xMin;
  
    // configure active depth
    int kinectNear = 500;
    int kinectFar = 2500;
    int silhouetteNear = 600;
    int silhouetteFar = 1800;
  
    noStroke();
    fill(255);
  
    // loop through depth array 
    for(int i = 0; i < depthPoints.length; i += pixelSkip) {
      // get the depth in millimeter
      int x = i % depthW;
      int y = floor(i / depthW);
      int gridIndex = x + y * depthW;
      int curDepth = depthPoints[gridIndex];
      
      float mappedY = float(y) / float(480) * float(WINDOW_HEIGHT);
      
      // draw low-res depth data
      //if(curDepth > 0) {  // only draw depth point if there's good data
      //  // set color to reflect distance - darker if further away
      //  fill(map(curDepth, kinectNear, kinectFar, 255, 100));
      //  // draw the current point
      //  rect(x, y, pixelSkip, pixelSkip);
      //}
      
      if (x >= xMin && x <= xMax) {
        float mappedX = float(x - xMin) / xRange * WINDOW_WIDTH;
        // draw only values within silhouette range
        fill(255);
        if(curDepth > silhouetteNear && curDepth < silhouetteFar) {
          circle(mappedX, mappedY, pixelSkip * scale);
    
          for (int si = 0; si < numStars; si++) {
            stars[si].checkCollision(round(mappedX), round(mappedY));
          }
        }
      }
    }
  }
}
