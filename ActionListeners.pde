void keyPressed() {
  //  if (key == CODED) {
  if (key == ESC) {
    key = 0;  //clear the key so the sketch doesn't close
  }
  if (keyCode == UP || keyCode == 'W' || keyCode == 'w' || keyCode == ' ') {
    keyUp = true;
  }
  if (keyCode == DOWN || keyCode == 'S' || keyCode == 's') {
    keyDown = true;
  }
  if (keyCode == LEFT || keyCode == 'A' || keyCode == 'a') {
    keyLeft = true;
  }
  if (keyCode == RIGHT || keyCode == 'D' || keyCode == 'd') {
    keyRight = true;
  }
  if (keyCode == SHIFT){
    keyShift = true;
  }
  //  }
}
void keyReleased() {
  //  if (key == CODED) {
  if (keyCode == UP || keyCode == 'W' || keyCode == 'w' || keyCode == ' ') {
    keyUp = false;
  }
  if (keyCode == DOWN || keyCode == 'S' || keyCode == 's') {
    keyDown = false;
  }
  if (keyCode == LEFT || keyCode == 'A' || keyCode == 'a') {
    keyLeft = false;
  }
  if (keyCode == RIGHT || keyCode == 'D' || keyCode == 'd') {
    keyRight = false;
  }
  if (keyCode == SHIFT){
    keyShift = false;
  }
  //  }
}

void getMouseCoordinates() {//update mouse coordinates
  px = mouseX;
  py = mouseY; 
  //println(px, py);
}
