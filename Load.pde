//using these strings so that there is less typing when inputing files in parameters
final String font = "fonts" + '/';

final String gameAsset = "gameAssets" + '/';

final String entities = gameAsset + "entities" + '/';
final String backdrop = gameAsset + "backdrops" + '/';
final String tiles = gameAsset + "caveTileSet" + '/';
final String popup = gameAsset + "popUps" + '/';

final String button = gameAsset + "UI_buttons" + '/';
final String rectButton = button + "largeButtons" + '/';
final String squButton = button + "squareButtons" + '/';

final String sound = gameAsset + "sound" + '/';
final String FX = sound + "FX" + '/';
final String music = sound + "music" + '/';

PFont unispace;
Animation waterfallBackdrop, player, diamond;
Image shiftImage, wasdImage, victoryImage,
      playButton, newGameButton, optionsButton, exitButton, backButton, //fScreenButton, windowedButton,
      homeSqrButton, optionsSqrButton,
      gameSoundButton, GUISoundButton, ambienceSoundButton, musicButton, infoButton, restartButton,
      platform1, platform2, platform3, platform4, platform5, platform6, spikes, spikeBall, mushroom,
      caveBackdrop1, caveBackdrop2, caveBackdrop3, caveBackdrop4;
Diamonds dL1, dL2, dL3, dL4, dL5;
Mushroom mL2;
SoundFile pressedSound,
          deathNoise,
          waterfall, cave, waterDrip, waterFlow,
          themeTrack, track1, track2;
StageSounds SThemeTrack, STrack2, SWaterfall, SCave, SWaterDrip;
UpdateSoundValue GUISound, gameSound, ambienceSound, musicSound;

void loadImages() {
  //popups
  shiftImage = new Image(popup + "shiftToSprint", null, 450, 80, null);
  shiftImage.opaque(true, 128);
  wasdImage = new Image(popup + "wasdToMove", null, 170, 40, null);
  wasdImage.opaque(true, 128);
  victoryImage = new Image(popup + "youWinMessage", null, 250, 40, null);
  
  //backdrops
  caveBackdrop1 = new Image(backdrop + "pixelCaveBackdrop1", null, 0, 0, null);
  caveBackdrop1.rescale(0.62);
  caveBackdrop2 = new Image(backdrop + "pixelCaveBackdrop2", null, 0, 0, null);
  caveBackdrop2.rescale(0.62);
  caveBackdrop3 = new Image(backdrop + "pixelCaveBackdrop3", null, 0, 0, null);
  caveBackdrop3.rescale(0.60);
  caveBackdrop4 = new Image(backdrop + "pixelCaveBackdrop4", null, 0, 0, null);
  caveBackdrop4.rescale(0.62);
  
  //buttons || ('rescale' is changing size by percentage)
  //Home Screen
  playButton = new Image(rectButton + "playButton", rectButton + "playColButton", 290, 100, "BUTTON");
  playButton.rescale(0.30);
  newGameButton = new Image(rectButton + "newGameButton", rectButton + "newGameColButton", 0, 0, "BUTTON");
  newGameButton.rescale(0.30);
  optionsButton = new Image(rectButton + "optionsButton", rectButton + "optionsColButton", 290, 200, "BUTTON");
  optionsButton.rescale(0.30);
  exitButton = new Image(rectButton + "exitButton", rectButton + "exitColButton", 310, 300, "BUTTON");
  exitButton.rescale(0.25);
  
  //Game Screen
  homeSqrButton = new Image(squButton + "homeSquareButton", squButton + "homeColSquareButton", 10, 10, "BUTTON");
  homeSqrButton.opaque(true, 150);
  homeSqrButton.rescale(0.20);
  optionsSqrButton = new Image(squButton + "settingsSquareButton", squButton + "settingsColSquareButton", 60, 10, "BUTTON");
  optionsSqrButton.opaque(true, 150);
  optionsSqrButton.rescale(0.20);
  
  //Settings Screen
  backButton = new Image(rectButton + "backButton", rectButton + "backColButton", 10, 10, "BUTTON");
  backButton.rescale(0.20);
  //fScreenButton = new Image(rectButton + "fullScreenButton", rectButton + "fullScreenColButton");
  //fScreenButton.rescale(0.35);
  //windowedButton = new Image(rectButton + "windowedButton", rectButton + "windowedColButton");
  //windowedButton.rescale(0.35);
  gameSoundButton = new Image(squButton + "audioSquareButton", squButton + "audioColSquareButton", 0, 0, "BUTTON");
  gameSoundButton.rescale(0.23);
  GUISoundButton = new Image(squButton + "audioSquareButton", squButton + "audioColSquareButton", 0, 0, "BUTTON");
  GUISoundButton.rescale(0.23);
  ambienceSoundButton = new Image(squButton + "audioSquareButton", squButton + "audioColSquareButton", 0, 0, "BUTTON");
  ambienceSoundButton.rescale(0.23);
  musicButton = new Image(squButton + "musicSquareButton", squButton + "musicColSquareButton", 0, 0, "BUTTON");
  musicButton.rescale(0.23);
  infoButton = new Image(squButton + "questionMarkSquareButton", squButton + "questionMarkColSquareButton", 600, 355, "BUTTON");
  infoButton.rescale(0.20);
  
  //End Screen
  restartButton = new Image(rectButton + "menuButton", rectButton + "menuColButton", 285, 230, "BUTTON");
  restartButton.rescale(0.35);
  
  //game objects
  platform1 = new Image(tiles + "caveTile1", null, 0, 0, null);
  platform1.rescale(1.20);
  
  platform2 = new Image(tiles + "caveTile2", null, 0, 0, null);
  platform2.rescale(1.10);
  
  platform3 = new Image(tiles + "caveTile3", null, 0, 0, null);
  platform3.rescale(0.90);
  
  platform4 = new Image(tiles + "caveTile4", null, 0, 0, null);
  platform4.rescale(1.20);
  
  platform5 = new Image(tiles + "caveTile5", null, 0, 0, null);
  platform5.rescale(1.20);
  
  platform6 = new Image(tiles + "caveTile6", null, 0, 0, null);
  platform6.rescale(1.20);
  
  spikes = new Image(tiles + "spikesTile", null, 0, 0, null);
  spikes.rescale(0.65);
  
  spikeBall = new Image(tiles + "spikeBall", null, 0, 0, null);
  //spikeBall.rescale(1.0);
  
  /*mushroom = new Image(tiles + "mushroom", null, 0, 0, null);
  mushroom.rescale(1.40);*/
}

void loadAnimations() {
  waterfallBackdrop = new Animation(backdrop+"waterfallGif"+'/'+"waterfall_", 4, true, 0, 0, width, height);
  
  player = new Animation(entities+"coatPlayer"+'/'+"coatPlayer_", 4, false, 0, 0, (int)playerWidth, (int)playerHeight);
  diamond = new Animation(entities+"diamond"+'/'+"diamond_", 60, false, 0, 0, 23, 23);
  
  dL1 = new Diamonds(diamond, 1);
  dL2 = new Diamonds(diamond, 2);
  mL2 = new Mushroom(2);
}

void loadSounds() {
  pressedSound = new SoundFile(this, FX + "pressed2.wav");
  
  deathNoise = new SoundFile(this, FX + "deathNoise.wav");
  
  SThemeTrack = new StageSounds(themeTrack, music + "themeTrack", true);
  STrack2 = new StageSounds(track2, music + "track2", true);
  SWaterfall = new StageSounds(waterfall, FX + "waterfall", true);
  SCave = new StageSounds(cave, FX + "caveNoises", true);
  SWaterDrip = new StageSounds(waterDrip, FX + "caveWaterDripSound", true);
}

void loadFonts() {
  unispace = loadFont("Unispace-Bold-48.vlw");
}

//reloads imagery (depends), pauses uneccary sound, and changes the stage
void reload(boolean reloadAll, int designatedStage) {
  if (reloadAll) {
    loadImages();
    loadAnimations();
  }
  pauseSound(stage);
  stage = designatedStage;
}
