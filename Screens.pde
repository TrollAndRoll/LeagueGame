void homeScreen() {
  setupScreen();//see function for explanation
  
  //gifs:
  waterfallBackdrop.running(true);//makes sure that animation plays
  waterfallBackdrop.display();//makes waterfall ocupy whole sketch

  //images:
  playButton.display();
  optionsButton.display();
  exitButton.display();

  //reload([reload images & Animations?], [transition to stage:])
  if (playButton.clicked() == true) reload(false, 1);//begin gameScreen() when playButton is clicked
  else if (optionsButton.clicked() == true) reload(false, 2);//open options screen when options button clicked
  else if (exitButton.clicked() == true) exit();//close the program if exit button pressed
}

void endScreen(){
  setupScreen();
  
  caveBackdrop1.display();
  
  victoryImage.display();
  restartButton.display();
  
  if(restartButton.clicked()) reload(true, 0);
}

/*______________________________________________________________________________________________*/

//ints that change the spacing of the buttons, labels, & lines
//settingsBtnX: x value of all buttons || iniButY: y value of first button || 
//dist: distance between buttons || txtDistFromBtn: distance between buttons and their labels ||
//iniTxtY: y value of the first label
int settingsBtnX = 170, iniButY = 75, dist = 70;
int txtDistFromBtn = settingsBtnX + dist, iniTxtY = 110;
void settingsScreen() {
  setupScreen();
  
  textFont(unispace);//set font
  textSize(28);//set txt size

  //images:
  caveBackdrop1.display();
  backButton.display();
  drawSettingBtns();//(see function(s) for explination)
  infoButton.display();

  updateSoundSettings();//see function for explination

  if (backButton.clicked() == true) reload(true, 0);//if back button click, go to main menu
  if (infoButton.clicked() == true) reload(true, 2);//on infoButton click...
}

//if (fullscreen == false){ //might use this if I figure out a way around the fullScreen() thing
//  fScreenButton.display(270, 250, "BUTTON");
//}
//else windowedButton.display(270, 250, "BUTTON");

//if (fScreenButton.clicked() == true) fullscreen = true; //loadImages();
//if (windowedButton.clicked() == true) fullscreen = false; //loadImages();
//}

/*______________________________________________________________________________________________*/

void setupScreen(){
  getMouseCoordinates();//updates mouse cords if told from parameter
  playAppropiateSounds();//(see function for explination)
  scale(width/iniWidth, height/iniHeight);//makes everything draw after preportional to window
}

/*______________________________________________________________________________________________*/

//Draw the "cancel" line over a settings button if it's value is false
void drawLineChecker(int linNum, Image btn, boolean settingOn) {
  if (settingOn == false) {//only show line is setting in question is off
    if (btn.selected()) {/*resize/recolor the line in correlation with*/
      stroke(#BD0000);   /*the button (when mouse hovers over)*/
      strokeWeight(6);
    } else {
      stroke(#F2F2F2);
      strokeWeight(4);
    }
    //draw line
    line((settingsBtnX-5), (iniButY-5)+(dist*linNum), (settingsBtnX+50), (iniButY+50)+(dist*linNum));
  }
}

//draws a button with it's lable and functioning 'cancel' line
void drawStgsBtn(int btnNum, String buttonLabel, Image btn, Boolean settOn) {
  text(buttonLabel, txtDistFromBtn, iniTxtY+(dist*btnNum)); //draw the label
  btn.setX(settingsBtnX); btn.setY(iniButY+(dist*btnNum)); //set all the button's new x & y values
  btn.display();//draw the button
  drawLineChecker(btnNum, btn, settOn);//draw the line (potentially) (using our drawLineChecker())
}

//draws all (4) fully functioning buttons using our drawStgsBtn() function
void drawSettingBtns() {
  drawStgsBtn(0, "GUI Sounds", GUISoundButton, GUISoundOn); 
  drawStgsBtn(1, "In-Game Sounds", gameSoundButton, inGameSoundOn);
  drawStgsBtn(2, "Ambience", ambienceSoundButton, ambienceOn); 
  drawStgsBtn(3, "Music", musicButton, musicOn); 
  noStroke();//so stroke (for drawing 'canceled' line) doesn't effect future shapes
}
