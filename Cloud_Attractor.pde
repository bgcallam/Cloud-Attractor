import processing.opengl.*;
import processing.video.*;
import imageadjuster.*;
import blobDetection.*;


// *********************
// ***** To do:
// ***** multi scree/fullscreen
// ***** color
// ***** make 2 modes? one with the differenced and one without?
// ***** text?
// ***** motion instead?
// *********************


ImageAdjuster adjust = new ImageAdjuster(this);
BgSubtract movieMask;
BlobDetection theBlobDetection;
Blob[] theBiggestBlobs;
CloudAttractor cloud;
QuickAreaBlobSort qabs;

Capture myMovie; 
PImage imgSmall;
int imageWidth = 1280;
int imageHeight = 1024;
int numberOfAttractions =1;
boolean newFrame=false;


void setup() {
  size(imageWidth, imageHeight, OPENGL);
  background(0);

  cloud = new CloudAttractor(imageWidth,imageHeight, numberOfAttractions );
  // Load and play the video in a loop
  myMovie = new Capture(this, imageWidth, imageHeight, 30); 
  //myMovie.settings();

  imgSmall = new PImage(imageWidth/5,imageHeight/5);
  movieMask = new BgSubtract(imgSmall);
  theBlobDetection = new BlobDetection(imgSmall.width, imgSmall.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f;
  theBlobDetection.activeCustomFilter(this);
  //adjust.contrast(1.25f);
}

// ==================================================
// captureEvent()
// ==================================================
void captureEvent(Capture cam)
{
  myMovie.read();
  newFrame = true;
}


void draw() {
  if (newFrame)
  {
    newFrame=false;
    //loadPixels();
    //myMovie.pixels = reverse(myMovie.pixels);
    // tint(255, 20);
    adjust.reset();

    //image(myMovie,0,0,width,height);




    imgSmall.copy(myMovie, 0, 0, myMovie.width, myMovie.height, 0, 0, imgSmall.width, imgSmall.height);
    adjust.apply(imgSmall);
    imgSmall.pixels =  movieMask.processImage(imgSmall);




    fastblur(imgSmall, 2);
    theBlobDetection.computeBlobs(imgSmall.pixels);
    //drawBlobCentroids();
    theBiggestBlobs = findBiggestBlobs();
    if(theBiggestBlobs!=null){
      for(int i=0;i<theBiggestBlobs.length;i++){
        cloud.addParticle((int)(theBiggestBlobs[i].x*imageWidth),(int)(theBiggestBlobs[i].y*imageHeight), (float)(theBiggestBlobs[i].w*theBiggestBlobs[i].h*myMovie.width*myMovie.height));
      }  
    }
    //image(imgSmall, 0, 0);

    //loadpixels()
    // Draws the particles
    cloud.evalSystem(); 
    image(imgSmall, 0, 0);

    // the rectangle
    /*if(theBiggestBlobs!=null){
     noFill();
     strokeWeight(1);
     stroke(255,0,0);
     for(int i=0;i<theBiggestBlobs.length;i++){
     rect( theBiggestBlobs[i].xMin*width,theBiggestBlobs[i].yMin*height, theBiggestBlobs[i].w*width,theBiggestBlobs[i].h*height );
     }  
     } */
    //updatePixels();

  }
}

void keyPressed() {
  loadPixels();
  movieMask.activate(myMovie);
  cloud = new CloudAttractor(imageWidth,imageHeight,numberOfAttractions);
}

// --------------------------------------------
// newBlobDetectedEvent()
// Filtering blobs here (discard "little" ones)
// --------------------------------------------
boolean newBlobDetectedEvent(Blob b)
{
  int w = (int)(b.w * imgSmall.width);
  int h = (int)(b.h * imgSmall.height);
  if (w >= 20 || h >= 20)
    return true;
  return false;
}

// --------------------------------------------
// findBiggestBlob()
// --------------------------------------------
Blob[] findBiggestBlobs()
{
  Blob[] biggestBlobs = new Blob[0];
  int numBlobs = theBlobDetection.getBlobNb();
  //float[] areas = new float[theBlobDetection.getBlobNb()];
  float surface = 0.0f;
  float surfaceMax = 0.0f;
  AreaBlob[] areaBlobs = new AreaBlob[numBlobs];

  for (int i=0;i<numBlobs;i++)
  {
    areaBlobs[i] = new AreaBlob(theBlobDetection.getBlob(i));
  }

  qabs = new QuickAreaBlobSort(areaBlobs);
  areaBlobs = qabs.sort();

  for(int i=0;i<numberOfAttractions && i<numBlobs;i++){
    biggestBlobs = (Blob[])append(biggestBlobs,areaBlobs[i].getBlob());
    println("blob" + i + " size: " + areaBlobs[i].getArea());
  }
  //biggestBlob.x = 1-biggestBlob.x;
  return biggestBlobs; 
}
