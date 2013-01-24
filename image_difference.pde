//------------------------------------------------------------
// ImageDifference Class
//------------------------------------------------------------

class ImageDiff
{
  int numPixels; 
  int threshold ;
  int[] previousFrame; 
  //int[] currentFrame; 

  /* Alternate constructor
  ImageDiff(int pxlNum ){
    // Some good numbers to start with.
    println("small constructor");
    new ImageDiff(pxlNum,0);
  }*/

  ImageDiff(int pxlNum) { 
    // Uses the default video input, see the reference if this causes an error 
    this.threshold = 0;
    this.numPixels = pxlNum;
    //this.numPixels = original.width * original.height;
    this.previousFrame = new int[numPixels];
    
    for(int i=0;i<numPixels;i++){
      previousFrame[i]= color(0xCC006699);
    }
    //numPixels = currentFrame.width * currentFrame.height; 
    // Create an array to store the previously captured frame 
    // previousFrame = new int[numPixels]; 
    //loadPixels(); 
  } 

  // Should return Null if not enough change
  int[] processImage(int[] thisFrame) { 
    //if (video.available()) { 
    // When using video to manipulate the screen, use video.available() and 
    // video.read() inside the draw() method so that it's safe to draw to the screen 
    //video.read(); // Read the new frame from the camera 
    //video.loadPixels(); // Make its pixels[] array available 
    int[] movementMask;
    movementMask = new int[numPixels];
    int movementSum = 0; // Amount of movement in the frame 

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame... 
      color currColor = thisFrame[i]; 
      color prevColor = previousFrame[i]; 
      // Extract the red, green, and blue components from current pixel 
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster 
      int currG = (currColor >> 8) & 0xFF; 
      int currB = currColor & 0xFF; 
      // Extract red, green, and blue components from previous pixel 
      int prevR = (prevColor >> 16) & 0xFF; 
      int prevG = (prevColor >> 8) & 0xFF; 
      int prevB = prevColor & 0xFF; 
      // Compute the difference of the red, green, and blue values 
      int diffR = abs(currR - prevR); 
      int diffG = abs(currG - prevG); 
      int diffB = abs(currB - prevB); 
      // Add these differences to the running tally 
      movementSum += diffR + diffG + diffB; 

      // ** here need to sum surrounding pixels? http://processing.org/reference/get_.html
      // Render the difference image to the screen 
      //pixels[i] = color(diffR, diffG, diffB); 
      // The following line is much faster, but more confusing to read 
      // ** Convert to grayscale? Y = 0.3*R + 0.59*G + 0.11*B
      movementMask[i] = color(int((0.3*diffR) + (.59*diffG) + (.11*diffB))); 
      //println("print this?" +currR);
      //movementMask[i] = 0xff000000 | (diffR << 16) | (diffG <<  8) | diffB; 
      // Save the current color into the 'previous' buffer 

      //if (frameCount%10 == 0) {
      previousFrame[i] = currColor; 
      // }
    } 

    // To prevent flicker from frames that are all black (no movement), 
    // only update the screen if the image has changed. 
    // 50000 is a good number? why? for 640X480 don't know fix this later...
    println(movementSum);    
    if (movementSum > threshold) { 
      return movementMask; // Print the total amount of movement to the console 
    } 
    else { 
      return null; 
    }

  }  
}
