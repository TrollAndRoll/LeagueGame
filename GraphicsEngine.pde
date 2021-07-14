public class Image {
  String type;
  int opaqueValue;
  PImage image1, image2;
  float rw, rh, rx, ry, pxz, pyz;//pxz/pyz = adjusted mouse coordinates
  boolean selected, pressed, played, opaque;
  SoundFile selectedFile = new SoundFile(Main.this, FX + "selected.wav");
  //selected.wav is only used for buttons (a kind of image) so I initialize it here

  Image(String image1Name, String image2Name, float rx, float ry, String type) {
    image1 = loadImage(image1Name + ".png");
    if (image2Name != null) {//only load second parameter if its not empty (otherwise program would stop :/)
      image2 = loadImage(image2Name + ".png");
    }
    //area to check for collision in is equal to that of the image dimensions.
    this.rx = rx;
    this.ry = ry;
    this.type = type;
    rw = image1.width;
    rh = image1.height;
  }

  public void rescale(float percent) {//rescales images by percentage
    rw = rw * percent;
    rh = rh * percent;
  }

  public void display() {
    if (type == "BUTTON") {//only do button things if it is said to be a "BUTTON" (when called)
      pxz = px/(width/iniWidth);//recalobrating to account for scale()
      pyz = py/(height/iniHeight);
      // is the point inside the rectangle's bounds?
      if (pxz >= rx &&      // right of the left edge AND
        pxz <= rx + rw &&   // left of the right edge AND
        pyz >= ry &&        // below the top AND
        pyz <= ry + rh) {   // above the bottom
        selected = true;
      } else {
        selected = false;
      }
      if (selected) {//if mouse is over button...
        if (selectedFile.isPlaying() == false && played == false) {//play "selected" noise
          if (GUISoundOn) selectedFile.play();
          played = true;
        }
        if (opaque) {
          tint(255, opaqueValue);
        }
        image(image2, rx-(rx*0.015), ry-(ry*0.015), rw*1.05, rh*1.05);//draw button slightly larger
        noTint();
        if (mousePressed && (mouseButton == LEFT)) {//if button was clicked then play "pressed" noise
          if (GUISoundOn) pressedSound.play();
          pressed = true;
        }
      } else {//if mouse is not over button...
        if (opaque) {
          tint(255, opaqueValue);
        }
        image(image1, rx, ry, rw, rh);//just draw a regular button
        noTint();
        played = false;
      }
    } else {//if its not a button then just draw the image
      if (opaque) {
        tint(255, opaqueValue);
      }
      image(image1, rx, ry, rw, rh);
      noTint();
    }
  }

  public boolean selected() {//getter to check, elsewhere, if buttons have been clicked
    return selected;
  }

  public boolean clicked() {//getter to check, elsewhere, if buttons have been clicked
    return pressed;
  }

  public float x() {//returns image's x coordinate
    return rx;
  }
  public float y() {//returns image's y coordinate
    return ry;
  }

  public float w() {//returns image's x coordinate
    return rw;
  }
  public float h() {//returns image's y coordinate
    return rh;
  }

  public String getType() {//reutrns the type of image it is (i.e. "BUTTON" or otherwise)
    return type;
  }

  public void opaque(boolean opaque, int opaqueValue) {
    this.opaqueValue = opaqueValue;
    this.opaque = opaque;
  }

  public void setX(float rx) {//can be used to set image's x coordinate
    this.rx = rx;
  }

  public void setY(float ry) {//can be used to set image's y coordinate
    this.ry = ry;
  }

  public void setType(String type) {//can be used to set the image's 'type'
    this.type = type;
  }
}

// Class for animating a sequence of GIFs
class Animation {
  PImage[] images;//array of images (all the ones in the GIF)
  int imageCount, frame, framesPerSecond = 15, transparency = 255;
  long startTime;
  float timePerFrame;
  float xpos, ypos, w, h;//class' positioning variables
  float wz, hz;//variables for recalobrated width & height
  boolean dynamicDimensions;//will the inputed width & height change?
  boolean run = true;//should the animation play?
  boolean facingLeft;//should a sprite be mirrored on y-axis?
  boolean fade;//If true, enact tint() until transparent

  Animation(String imagePrefix, int count, boolean dynamicDimensions, float xpos, float ypos, float w, float h) {
    this.dynamicDimensions = dynamicDimensions;
    this.startTime = System.currentTimeMillis();//returns time in millis between now & midnight
    this.timePerFrame = 1.0f / (float)framesPerSecond;//saves fps in timePerFrame float
    this.xpos = xpos;//pass local variables into the rest of the class
    this.ypos = ypos;
    this.w = w;
    this.h = h;

    imageCount = count;//sets the amount of images in GIF as a local variable
    images = new PImage[imageCount];//initializes 'images' array to be as big as the amount of images in the GIF

    for (int i = 0; i < imageCount; i++) {//goes through the array filling each slot with an image
      // Use nf() to number format 'i' into however many digits (set to 1 rn)
      String filename = imagePrefix + nf(i, 1) + ".gif";//we can do this because of how the files are named
      images[i] = loadImage(filename);//setting the array slot to the image
    }
  }

  Animation(Animation animation) {
    this.dynamicDimensions = animation.dynamicDimensions;
    this.startTime = System.currentTimeMillis();//returns time in millis between now & midnight
    this.timePerFrame = 1.0f / (float)framesPerSecond;//saves fps in timePerFrame float
    this.xpos = animation.xpos;//pass local variables into the rest of the class
    this.ypos = animation.ypos;
    this.w = animation.w;
    this.h = animation.h;

    this.imageCount = animation.imageCount;//sets the amount of images in GIF as a local variable
    images = animation.images;
  }

  public void setFrameRate(int rate) {//method to change the frame rate of the animation
    this.framesPerSecond = rate;
    this.timePerFrame = 1.0f / (float)framesPerSecond;
  }

  public void display() {
    if (run) {//if run is true, the play animation
      //checks how much time has elapsed between now and when the class was called
      float epsilon = (float)(((double)System.currentTimeMillis() - (double)startTime) / 1000.0);
      if (epsilon > timePerFrame) {//once time between frames is greater than the desire frame rate...
        frame++;//go to the next frame
        if (frame >= imageCount) {//reset the first image once we hit the end of the array
          frame = 0;
        }
        startTime = System.currentTimeMillis();//makes start time current time so that epilson is the time between frames
      }
      run = false;//set false because run variable should only be true if it was set so using "running(true)"
    } else {//if the player isn't running...
      frame = 0;//set the player sprite to its passive stance (frame 0)
    }
    //println(epsilon);
    //this.w = w;
    //this.h = h;
    if (dynamicDimensions) {//(essentially reserved for backgrounds 'cause their dimensions are the width/height variables)
      wz = w/(width/iniWidth);//recalobrating to account for scale()
      hz = h/(height/iniHeight);
    } else {
      wz = w;
      hz = h;
    }
    if (facingLeft) {
      pushMatrix();
      translate(wz, 0);
      scale(-1, 1); //mirrors image
      image(images[frame], -xpos, ypos, wz, hz);//display the current frame at inputed position and width/height
      popMatrix();
    } else {
      image(images[frame], xpos, ypos, wz, hz);//display the current frame at inputed position and width/height
    }
    if (fade) {
      if (transparency > 0) { 
        transparency -= 0.25;
      } else {
        transparency = 255;
        fade = false;
        noTint();
      }
      tint(255, transparency);
    }
  }

  public int getFrame() {//return the frame the animation is on
    return frame;
  }

  public float x() {//returns gif's x position
    return xpos;
  }

  public float y() {//returns gif's y position
    return ypos;
  }

  public float w() {//returns gif's width
    return wz;
  }

  public float h() {//returns gif's width
    return hz;
  }

  public int getWidth() {
    return images[0].width;//returns the actual width of the GIF (assuming all frames are the same widht as frame 1)
  }

  public boolean isRunning() {
    return run;
  }

  public void fade() {
    fade = true;
  }

  public boolean getFade() {
    if (fade) {
      return true;
    }
    return false;
  }

  public void running(boolean run) {
    this.run = run;//set local run equal to whatever was passed in
  }

  public void facingLeft(boolean facingLeft) {
    this.facingLeft = facingLeft;//set local facingLeft equal to whatever was passed in
  }

  public void setFrame(int frame) {//updates the animation frame to the inputed number
    this.frame = frame;
  }

  public void setX(float x) {//can be used to set gif's x coordinate
    xpos = x;
  }

  public void setY(float y) {//can be used to set gif's y coordinate
    ypos = y;
  }
}
