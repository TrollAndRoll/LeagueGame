import processing.sound.*;

int stage = 0;//set where the game starts
int frameRate = 60;

final float iniWidth = 768;//initial window dimentions
final float iniHeight = 432;

float px = 0, py = 0;//Mouse x & y
boolean fullscreen;//probably wont use this- turns out you can only call fullScreen()/size() once :(

void setup() {
  size(768, 432, P2D);//16:9
  //fullScreen(P2D);
  background(255);
  frameRate(frameRate);
  //smooth();
  //x = width*0.08333;
  //y = height*0.5;
  surface.setTitle("Cave Explorer");
  surface.setResizable(true);
  surface.setLocation(550, 250);
  //surface.setAlwaysOnTop(true);

  loadFonts();
  loadImages();
  loadAnimations();
  loadSounds();
}

void draw() {
  if (stage == 0) {
    homeScreen();
  }
  else if (stage == 1) {
    gameScreen();
  }
  else if (stage == 2) {
    settingsScreen();
  }
  else if (stage == 3) {
    endScreen();
  }
}
