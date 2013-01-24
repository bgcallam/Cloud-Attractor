/**
 * Background Subtraction 
 * by Golan Levin. 
 * 
 * Detect the presence of people and objects in the frame using a simple
 * background-subtraction technique. To initialize the background, press a key.
 */

class BgSubtract
{
  int numPixels;
  PImage backgroundPixels;
  //Capture video;

  BgSubtract(PImage newImage) {
    // Change size to 320 x 240 if too slow at 640 x 480
    //size(640, 480); 

    //video = new Capture(this, width, height, 24);
    numPixels = newImage.pixels.length;
    // Create array to store the background image
    backgroundPixels = new PImage(newImage.width,newImage.height);
    // Make the pixels[] array available for direct manipulation
    //loadPixels();
  }

  int[] processImage(PImage thisFrame) {
    //if (video.available()) 
    //  video.read(); // Read a new video frame
    //  video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    int[] diffMask;
    diffMask = new int[numPixels];
    int presenceSum = 0;

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = thisFrame.pixels[i];
      color bkgdColor = backgroundPixels.pixels[i];
      // Extract the red, green, and blue components of the current pixel’s color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel’s color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      
      // Render the difference image to the screen (changing it to grayscale)
      if((diffR+diffG+diffB)>10){
        diffMask[i] = color(int((0.3*diffR) + (.59*diffG) + (.11*diffB)));
      }
      else{
        diffMask[i] = color(0,0,0);
      }
      //diffMask[i] = color(int((0.3*diffR) + (.59*diffG) + (.11*diffB)));
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    //updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum); // Print out the total amount of movement
    if(presenceSum>0){
      //arraycopy(diffMask,thisFrame.pixels);
      return diffMask;
    }
    else{ 
      return thisFrame.pixels;
    }     
  }

  // Capture the background image into the backgroundPixels buffer, by copying each of the current frame’s pixels into it.
  void activate(PImage thisFrame) {
    //video.loadPixels();
    
    backgroundPixels.copy(thisFrame,0,0,thisFrame.width,thisFrame.height,0,0,backgroundPixels.width,backgroundPixels.height);
  }
}
