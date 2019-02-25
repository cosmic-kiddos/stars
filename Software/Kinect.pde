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
}