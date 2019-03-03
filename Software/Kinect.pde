import SimpleOpenNI.*;

SimpleOpenNI context;

void initKinect() {
  context = new SimpleOpenNI(this);

  if (context.isInit() == false) {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  context.setMirror(false);
  context.enableDepth();
}

void updateKinect() {
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

  noStroke(); 
  fill(255);

  // loop through depth array 
  for(int i = 0; i < depthPoints.length; i += pixelSkip){
    // get the depth in millimeter
    int x = i % depthW;
    int y = floor(i / depthW);
    int gridIndex = x + y * depthW;
    int curDepth = depthPoints[gridIndex];
    
    // draw low-res depth data
    if(curDepth > 0) {  // only draw depth point if there's good data
      // set color to reflect distance - darker if further away
      fill(map(curDepth, kinectNear, kinectFar, 255, 100));
      // draw the current point
      rect(x, y, pixelSkip, pixelSkip);
    }
    
    // draw only values within silhouette range
    fill(255);
    if(curDepth > silhouetteNear && curDepth < silhouetteFar) {
      rect(depthW + x, y, pixelSkip, pixelSkip);
    }
  }
}