boolean musicOn = true, GUISoundOn = true, inGameSoundOn = true, ambienceOn = true;//sound settings

void updateSoundSettings() {
  GUISound = new UpdateSoundValue(GUISoundOn);//1.create instance & get current setting (boolean) value
  GUISound.updateSoundValue(GUISoundButton.clicked());//2.on button click: find opposite of setting (boolean) value
  GUISoundOn = GUISound.getUpdatedValue();//3.set old setting value to the new one from step 2

  gameSound = new UpdateSoundValue(inGameSoundOn);
  gameSound.updateSoundValue(gameSoundButton.clicked());
  inGameSoundOn = gameSound.getUpdatedValue();

  ambienceSound = new UpdateSoundValue(ambienceOn);
  ambienceSound.updateSoundValue(ambienceSoundButton.clicked());
  ambienceOn = ambienceSound.getUpdatedValue();

  musicSound = new UpdateSoundValue(musicOn);
  musicSound.updateSoundValue(musicButton.clicked());
  musicOn = musicSound.getUpdatedValue();

  //println("|music: " + musicOn, "|GUI-Sound: " + GUISoundOn, "|Game Sound: " + inGameSoundOn, "|ambience: " + ambienceOn);
}

void playAppropiateSounds() { //play correct stageSounds according to what stage we're in & if the
  if (stage == 0) {           //appropiate setting is 'true'
    if (musicOn) {
      SThemeTrack.run();
    }
    if (ambienceOn) {
      SWaterfall.run();
    }
  } else if (stage == 1) {
    if (musicOn) {
      STrack2.run();
    }
  } else if (stage == 2) {
    if (ambienceOn) {
      SCave.run(); 
      SWaterDrip.run();
    }
  } else if (stage == 3) {
    if (ambienceOn) {
      SCave.run();
      SWaterDrip.run();
    }
  }
} 

void pauseSound(int stageNum) {//pause stageSounds that shouldn't play on that stage
  if (stageNum == 0) {
    //main menu sounds:
    SThemeTrack.pause();
    SWaterfall.pause();
  } else if (stageNum == 1) {
    STrack2.pause();
  } else if (stageNum == 2) {
    //settings sounds:
    SCave.pause(); 
    SWaterDrip.pause();
  } else if (stageNum == 3) {
    STrack2.pause();
    SCave.pause();
    SWaterDrip.pause();
  }
}

class UpdateSoundValue {
  boolean valueToUpdate;//the value of the setting being ckecked (beforehand)
  UpdateSoundValue(boolean valueToUpdate) {
    this.valueToUpdate = valueToUpdate;  //save paramater input as a local variable
  }
  void updateSoundValue(boolean clicked) {//input: pass in a .getClicked()
    if (clicked) {  //if button has infact been clicked...
      reload(true, 2); //reload: re-does buttons & background ('cause glitchy stuff otherwise)
      if (valueToUpdate) {  //if the value being checked is 'true'...
        valueToUpdate = false; //make it 'false'
      } else {//if it's 'false' make it 'true'
        valueToUpdate = true;
        //println(valueToUpdate);
      }
    }
  }
  boolean getUpdatedValue() {
    return valueToUpdate;
    //I usually return this value once it's gone through updateSoundValue(boolean) in order to
    //set the global setting boolean (look at line 1) to this update value
  }
}

class StageSounds {//this class was made because, unlike other sounds, stage sounds must be               
  SoundFile name;  //stopped upon switching scenes. I can just use .run() instead of having to use
  boolean soundPlayedOnce, paused, loop; //a bunch of if-statements for each stage sound

  StageSounds(SoundFile name, String fileName, boolean loop) {
    name = new SoundFile(Main.this, fileName + ".wav");//new instance of inputed soundFile

    //save inputed values as local values
    this.name = name;
    this.loop = loop;
  }

  //in hindsight- I think this isn't super efficient... there are like .loop() and .noLoop()
  //commands already built in but whatever m8, this works.
  void run() {
    if (loop) {//keep playing inputed file on repeat if loop = 'true'
      if (name.isPlaying() == false) {//if it's not playing, find out why...
        if (paused == true)name.play(); //if it was paused, simply play
        else {
          name.jump(0);//if it ended: go back to the start and play again
        }
        paused = false;
      }
    } else {//if loop is != 'true', only play once
      if (soundPlayedOnce == false) {
        if (name.isPlaying() == false) name.play(); 
        paused = false;
        soundPlayedOnce = true;
      }
    }
  }

  void pause() {//pause the file input in object parameter
    if (paused == false) {
      name.pause();
      paused = true;
    }
  }
}
