final int floor = 400; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
final float playerWidth = 15, playerHeight = 35; //25 & 55
float xSpeed = 0;
float xVelocity = 0.3;
final float yVelocityConst = -12.0;
float yVelocity = 0;
float gravity = 0.80;
float newPosition, objectHeight;
int level = 1;

boolean keyLeft, keyRight, keyUp, keyDown, keyShift, jump, touchingObject, alive, bigJump, spawnHasBeenSet = false;

void gameScreen() {
  setupScreen();
  background(0);
  fill(150, 100, 255);
  alive = true;
  if (level == 1) {
    map1();
  } else if (level == 2) {
    map2();
  } else if (level == 3) {
    stage = 3;
  }
  player.setFrameRate(4);
  player.display();//display player
  countSpeed();//updates velocity variables (given speed/gravity) and animation factors (i.e., running?, facingLeft?)
  changePlayerPosition();//actually updates x-coordinate
  //println("Player x: " + player.x() + ", Player y: " + player.y());

  xSpeed *= 0.9;//friction (ends in player stopped)
  //println(xSpeed);

  //Button Stuff
  homeSqrButton.display();
  optionsSqrButton.display();
  if (homeSqrButton.clicked()) {
    gameReset(); 
    reload(true, 0);
  } else if (optionsSqrButton.clicked()) {
    gameReset();
    reload(true, 2);
  }
}

void map1() {
  setPlayerTo(135, 250);
  caveBackdrop3.display();
  shiftImage.display();
  wasdImage.display();


  dL1.setDPos(0, 550, 260);
  dL1.touched();
  dL1.display();
  levelChanger(dL1);

  drawTile(platform4, 130, 300, true);//platform lenght = 230.4
  drawTile(platform5, 358, 300, true);

  drawSpikes();
  //println("Alive: "+ alive);

  deathCheck(dL1);
}

void map2() {
  setPlayerTo(250, 250); 
  caveBackdrop3.display();
  dL2.setDPos(0, 65, 300);

  dL2.setDPos(1, 740, 150);
  dL2.touched();
  dL2.display();
  levelChanger(dL2);

  drawSpikeBall(180, 200);
  mL2.setMPos(0, 280, 335);
  mL2.setMPos(1, 630, 335);
  mL2.gravityChange(1, 0.43);//standard boost: 0.45, standard: 0.8
  mL2.display();//draw mushrooms

  //println("X: " + (int)xSpeed + ", Y: " + yVelocity);
  drawTile(platform1, 50, 360, false);
  drawTile(platform1, 50, 330, true);//1st Tower

  drawTile(platform1, 200, 350, true);//2nd Tower

  drawTile(platform1, 350, 350, false);
  drawTile(platform1, 350, 300, false);
  drawTile(platform1, 350, 250, true);//3rd Tower

  drawTile(platform6, 600, 350, true);//4th Tower

  drawTile(platform6, 730, 390, false);
  drawTile(platform6, 730, 320, false);
  drawTile(platform6, 730, 250, false);
  drawTile(platform6, 730, 180, true);//5th Tower
  drawSpikes();

  deathCheck(dL2);
}

void map3() {
}

void countSpeed() {
  if (keyLeft) {//if left key pressed...
    xSpeed-= xVelocity;//speed decreases (goes left) at the rate of xVelocity
    player.running(true);//makes the animation play
    player.facingLeft(true);//mirrors the image to face left
  }
  if (keyRight) {//if right key pressed...
    xSpeed+= xVelocity;//speed increases (goes right) at the rate of xVelocity
    player.running(true);//animation plays
    player.facingLeft(false);//does nothing to image (will face right by default)
  }
  if (keyUp) {//if up key pressed...
    jump();
    player.running(true);//animation plays
  }
  if (keyShift) {
    xVelocity = 0.575;
    //println("sprinting");
  } else {
    xVelocity = 0.3;
    //println("not sprinting");
  }
}

void changePlayerPosition() {//updates player's x-coordinate
  player.setX(player.x() + xSpeed);//x position of player is incremented by xSpeed
  //Ensure player can't move off-screen
  if (player.x() < 0-2) {
    player.setX(0-2);
  } else if (player.x() > iniWidth-7) {
    player.setX(iniWidth-7);
  }

  yVelocity += gravity;//increases the speed by which the player falls (less is higher so: higher gravity = lower jump)
  player.setY(player.y() + yVelocity);//make player fall
  /*if (player.y() > (floor)) {//if going through floor...
   player.setY(floor);//set y position to floor
   yVelocity = 0;//& no more falling
   }*/
}

void setPlayerTo(int x, int y) {
  if (!spawnHasBeenSet) {
    player.setX(x);
    player.setY(y);
    spawnHasBeenSet = true;
    deathNoisePlayed = false;
  }
}

void levelChanger(Diamonds diamond) {
  if (diamond.levelCompleted()) {
    gameReset();
    level++;
  }
}

void gameReset() {
  yVelocity = 0;
  xSpeed = 0;
  spawnHasBeenSet = false;
}

void jump() {
  if (yVelocity == 0) {//if not in the air...
    yVelocity = yVelocityConst;
    keyUp = false;//make sure player can't jump in mid air
  }
}

boolean deathNoisePlayed, fading;
void deathCheck(Diamonds diamond) {
  if (!alive) {
    player.fade();
    fading = player.getFade();
    while (fading) {
      yVelocity = 0;
      xSpeed = 0;
      player.display();
      fading = player.getFade();
    }
    if (!deathNoisePlayed && inGameSoundOn) {
      deathNoise.play();
      deathNoisePlayed = true;
    }
    spawnHasBeenSet = false;
    diamond.restoreDiamonds();
    //reload(true, 3);//Moves to screen 3
  }
}

void drawSpikeBall(int x, int y) {
  if (drawTile(spikeBall, x, y, true)) {
    alive = false;
    //println("dead");
  }
}

void drawSpikes() {
  boolean touchingSpike1 = drawTile(spikes, 0, 390, true);
  boolean touchingSpike2 = drawTile(spikes, spikes.w()-10, 390, true);
  boolean touchingSpike3 = drawTile(spikes, (spikes.w()*2)-20, 390, true);
  if (touchingSpike1 || touchingSpike2 || touchingSpike3) {
    alive = false;
  }
}

//Sets coordinates of a game image/object (still only) before displaying it
boolean drawTile(Image tile, float x, float y, boolean solid) {
  boolean touching;
  tile.setX(x);
  tile.setY(y);
  tile.display();
  if (solid) {
    touching = handleSolidBlockCollision(tile);
  } else {
    touching = false;
  }
  return touching;
}

//Sets coordinates of a game image/object (Animated only) before displaying it
boolean drawTile(Animation tile, float x, float y) {
  tile.setX(x);
  tile.setY(y);
  tile.display();
  boolean touching = handleSolidBlockCollision(tile);
  return touching;
}

public class Mushroom {
  ArrayList<Image> mushroomList = new ArrayList<Image>();
  ArrayList<Boolean> touchedList = new ArrayList<Boolean>();
  ArrayList<Boolean> justTouchedList = new ArrayList<Boolean>();
  ArrayList<Float> gravChangeToList = new ArrayList<Float>();
  SoundFile mushroomSquish = new SoundFile(Main.this, FX + "mushroomSquish.wav");
  long startTime;
  int numOfMushrooms;
  float gravityChangeTo = 0.45;
  boolean justTouched, touched;

  Mushroom(int numOfMushrooms) {
    this.numOfMushrooms = numOfMushrooms;
    mushroomSquish.amp(0.3);
    for (int i = 0; i < numOfMushrooms; i++) {
      Image j = new Image(tiles + "mushroom", null, 0, 0, null);
      j.rescale(1.40);
      mushroomList.add(j);
      boolean d = false;
      touchedList.add(d);
      justTouchedList.add(d);
      float e = gravityChangeTo;
      gravChangeToList.add(e);
    }
  }

  void setMPos(int mushroomNum, int x, int y) {
    mushroomList.get(mushroomNum).setX(x);
    mushroomList.get(mushroomNum).setY(y);
  }

  void gravityChange(int whichShroom, float gravityChangeTo) {
    gravChangeToList.set(whichShroom, gravityChangeTo);
  }

  void display() {
    gravity = 0.80;
    for (int i = 0; i < numOfMushrooms; i++) {
      Image mush = mushroomList.get(i);
      mush.display();
      touchedList.set(i, handleSolidBlockCollision(mush));
      if (touchedList.get(i)) {
        bigJump = true;
        startTime = System.currentTimeMillis();
        if (!justTouchedList.get(i)) {
          if (inGameSoundOn) mushroomSquish.play();
          justTouchedList.set(i, true);
        }
      } else {
        justTouchedList.set(i, false);
      }

      if (bigJump) {
        float epsilon = (float)(((double)System.currentTimeMillis() - (double)startTime) / 1000.0);
        gravity = gravChangeToList.get(i);
        if (epsilon > 0.5f) {
          bigJump = false;
        }
      }
    }
  }
}

public class Diamonds {
  ArrayList<Animation> diamondList = new ArrayList<Animation>();
  ArrayList<Boolean> collectedList = new ArrayList<Boolean>();
  SoundFile diamondCollected = new SoundFile(Main.this, FX + "diamondCollected.wav");
  int diamondCount, collectedCount;

  Diamonds(Animation diamond, int diamondCount) {
    this.diamondCount = diamondCount;
    diamondCollected.amp(0.3);
    for (int i = 0; i < diamondCount; i++) {
      Animation d = new Animation(diamond);
      collectedList.add(false);
      diamondList.add(d);
    }
  }

  void touched() {
    boolean touched = false;
    for (int i = 0; i < diamondCount; i++) {
      if (collectedList.get(i) == false) {
        touched = handleSolidBlockCollision(diamondList.get(i));
      }
      if (touched) {
        collectedList.set(i, true);
        if (inGameSoundOn) diamondCollected.play();
      }
    }
  }

  void display() {
    for (int i = 0; i < diamondCount; i++) {
      if (collectedList.get(i) == false) {
        diamondList.get(i).running(true);
        diamondList.get(i).display();
      }
    }
  }

  void restoreDiamonds() {
    for (int i = 0; i < diamondCount; i++) {
      collectedList.set(i, false);
    }
  }

  boolean levelCompleted() {
    for (int i = 0; i < diamondCount; i++) {
      if (collectedList.get(i) == false) {
        return false;
      }
    }
    return true;
  }

  void setDPos(int diamondNum, float x, float y) {
    diamondList.get(diamondNum).setX(x);
    diamondList.get(diamondNum).setY(y);
  }

  public float getW() {
    return diamond.w();
  }

  public float getH() {
    return diamond.h();
  }
}

//Rectangle-Rectangle Collision Detection
boolean handleSolidBlockCollision(Image obstacle) {

  touchingObject = false;
  float nx = player.x() + xSpeed;//determines will where the player x will be next frame
  float ny = player.y() + yVelocity;//determines where the player y will be next frame

  if (xSpeed > 0) {//if player moving right then...
    if (nx + player.w > obstacle.x() && //if right side of player passes left side of the obstacle
      nx < obstacle.x() && //and left side of player is to left of obstacle 
      ny + player.h > obstacle.y() && //and the bottom of the player is below the obstacle
      ny < obstacle.y() + obstacle.h()) {//and the top of the player above the obstacle's bottom
      touchingObject = true;
      xSpeed = 0; //stop the player
      //println("X far enough: " + ((nx) + player.w > obstacle.x()) + ", Y far enough: " + (ny + player.h < obstacle.y()));
      //println("Player y: " + (player.y() + player.h()) + ", nPlayer y: " + (ny + player.h()) + ", obstacle y: " + obstacle.y());
      //println("Player x: " + (player.x() + player.w()) + ", nPlayer x: " + (nx + player.w()) + ", obstacle x: " + obstacle.x());
      if (yVelocity > 0.8 && nx + player.w > obstacle.x() && ny + player.h <= obstacle.y()) {//if falling (then you'll probably land on an obstacle so...)
        player.setY(obstacle.y() - player.h());//set player ontop of obstacle
        yVelocity = 0;//stop player
      } else {//if not falling
        player.setX(obstacle.x() - player.w());//set player to left of obstacle
      }
    }
  } else if (xSpeed < 0) {//if player moving left then...
    if (nx < obstacle.x() + obstacle.w() && //if left side of player passes right side of obstacle
      nx + player.w() > obstacle.x() + obstacle.w() && //and right side of player is to right of obstacle
      ny + player.h() > obstacle.y() &&//and bottom of player is below top of obstacle
      ny < obstacle.y() + obstacle.h()) {//and top of player is above the obstacle's bottom
      touchingObject = true;
      xSpeed = 0;//stop player
      if (yVelocity > 0.8 && nx < obstacle.x() + obstacle.w() && ny + player.h <= obstacle.y()) {//if falling (then you'll probably land on an obstacle so...) //(...ity > 0)
        player.setY(obstacle.y() - player.h());//set player ontop of obstacle
        yVelocity = 0;//stop player
      } else {//if not falling
        player.setX(obstacle.x() + obstacle.w());//set player to right of obstacle
      }
    }
  }
  if (yVelocity > 0) {//if falling
    if (ny + player.h > obstacle.y() &&//if the bottom of the player past the top of the obstacle
      ny < obstacle.y() &&//and the top of the player above the obstacle
      player.x() + player.w() > obstacle.x() &&//and the right of the player is past the obstacle's left
      player.x() < obstacle.x() + obstacle.w()) {//and the left of the player is to the left of the obstacle' right
      touchingObject = true;
      yVelocity = 0;//stop player
      player.setY(obstacle.y() - player.h());//set player's y to the base of the obstacle
    }
  } else if (yVelocity < 0) {//if jumping (in air)
    if (ny < obstacle.y() + obstacle.h() &&//if player's top is above obstacle's top
      ny + player.h() > obstacle.y() + obstacle.h() &&//and player's bottom is below top
      player.x() + player.w() > obstacle.x() &&//and player's right is to the right of obstacle's left
      player.x() < obstacle.x() + obstacle.w()) {//and player's left is to the left of obstacle's right
      touchingObject = true;
      yVelocity = 0;//stop player
      player.setY(obstacle.y() + obstacle.h());//set player's y to top of obstacle
    }
  }
  return touchingObject;
}

//Rectangle-(Animated)Rectangle Detection
boolean handleSolidBlockCollision(Animation obstacle) {

  touchingObject = false;
  float nx = player.x() + xSpeed;//determines will where the player x will be next frame
  float ny = player.y() + yVelocity;//determines where the player y will be next frame

  if (xSpeed > 0) {//if player moving right then...
    if (nx + player.w > obstacle.x() && //if right side of player passes left side of the obstacle
      nx < obstacle.x() && //and left side of player is to left of obstacle 
      ny + player.h > obstacle.y() && //and the bottom of the player is below the obstacle
      ny < obstacle.y() + obstacle.h()) {//and the top of the player above the obstacle's bottom
      touchingObject = true;
      //xSpeed = 0; //stop the player
      /*if (yVelocity > 0) {//if falling (then you'll probably land on an obstacle so...)
       player.setY(obstacle.y() - player.h());//set player ontop of obstacle
       } else {//if not falling
       player.setX(obstacle.x() - player.w());//set player to left of obstacle
       }*/
    }
  } else if (xSpeed < 0) {//if player moving left then...
    if (nx < obstacle.x() + obstacle.w() && //if left side of player passes right side of obstacle
      nx + player.w() > obstacle.x() + obstacle.w() && //and right side of player is to right of obstacle
      ny + player.h() > obstacle.y() &&//and bottom of player is below top of obstacle
      ny < obstacle.y() + obstacle.h()) {//and top of player is above the obstacle's bottom
      touchingObject = true;
      //xSpeed = 0;//stop player
      /*if (yVelocity > 0) {//if falling (then you'll probably land on an obstacle so...)
       player.setY(obstacle.y() - player.h());//set player ontop of obstacle
       } else {//if not falling
       player.setX(obstacle.x() + obstacle.w());//set player to right of obstacle
       }*/
    }
  }
  if (yVelocity > 0) {//if falling
    if (ny + player.h > obstacle.y() &&//if the bottom of the player past the top of the obstacle
      ny < obstacle.y() &&//and the top of the player above the obstacle
      player.x() + player.w() > obstacle.x() &&//and the right of the player is past the obstacle's left
      player.x() < obstacle.x() + obstacle.w()) {//and the left of the player is to the left of the obstacle' right
      touchingObject = true;
      //yVelocity = 0;//stop player
      //player.setY(obstacle.y() - player.h());//set player's y to the base of the obstacle
    }
  } else if (yVelocity < 0) {//if jumping (in air)
    if (ny < obstacle.y() + obstacle.h() &&//if player's top is above obstacle's top
      ny + player.h() > obstacle.y() + obstacle.h() &&//and player's bottom is below top
      player.x() + player.w() > obstacle.x() &&//and player's right is to the right of obstacle's left
      player.x() < obstacle.x() + obstacle.w()) {//and player's left is to the left of obstacle's right
      touchingObject = true;
      //yVelocity = 0;//stop player
      //player.setY(obstacle.y() + obstacle.h());//set player's y to top of obstacle
    }
  }
  return touchingObject;
}
