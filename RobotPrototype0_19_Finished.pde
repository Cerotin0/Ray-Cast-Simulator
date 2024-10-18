///////////////////////////////////////////
// Project by Aurimas Zilinskas 21755229 //
///////////////////////////////////////////

PFont f;       // General font style
PFont uif;     // Font style for the information inside the UI
boolean left, right, up, down;
int testSubject = 0; // Instead of having lives, we instead track how many times the player has died
int mostValuableTestSubject = 0; // Store the subject that had the highest score before they died

Player p;
Rectangles[] recs;
Traps[] traps;
Raycast ray;
UI ui;
Coin coin;
Console console;

// Rect values
int rectCount = 5;    // How many rectangles to spawn
int rectSize = 70;    // Width and height size
int rectVariance = 0; // Adds a -+ variance to size

// Trap values
int trapCount = 3;    // How many traps to spawn
int trapSize = 50;    // Width and height size
int trapVariance = 0; // Adds a -+ variance to size

// CONSOLE SETTINGS
int detectionType = 0;       // 0 = kick the player out once it's inside the rectangle
boolean nightmode = false;   // Turns the background black and makes shapes invisible
boolean debugmode = false;   // Shows player hitbox, raycast angle
boolean rayShowLines = true; // Show the 3 ray boundaries
boolean raycast = true;      // Shows the rays
boolean showOutlines = true; // Shows rect outline, use this when nightmode is on

// UI stuff
PImage uiBG;
PImage playerImg;
int fps;

void setup() {
  // OPENGL is another option, but unfortunately it runs really poorly with laptops without a
  // dedicated gpu
  size(1300, 900, P2D);
  //hint(DISABLE_OPTIMIZED_STROKE);
  //fullScreen();
  frameRate(60);
  smooth(4);
  f = createFont("Cambria", 20);    // Font for important stuff/headings
  uif = createFont("Consolas", 18); // Font for everything else

  //UI stuff
  textureMode(NORMAL);
  uiBG = loadImage("uiBG.png");
  playerImg = loadImage("player.png");

  p = new Player();
  recs = new Rectangles[rectCount];
  for (int i = 0; i < recs.length; i++) {
    recs[i] = new Rectangles();
  }
  traps = new Traps[trapCount];
  for (int i = 0; i < traps.length; i++) {
    traps[i] = new Traps();
  }

  ray = new Raycast();
  ui = new UI();
  coin = new Coin();
  coin.spawn();
  console = new Console();

  // Movement input booleans
  left = false;
  right = false;
  up = false;
  down = false;
}

void draw() {
  if (nightmode) background(0);
  else background(240);

  p.update();               // Updates the players position, rotation
  p.display();              // Renders the player model
  if (raycast)ray.display(); // Renders the raycast coming from the players eye
  coin.display();

  // Instantiates rectangles and traps
  for (int r = 0; r < recs.length; r++) {
    recs[r].update();
  }
  for (int t = 0; t < traps.length; t++) {
    traps[t].update();
  }

  // Updates UI after everything else to make it appear on top
  ui.Logic();

  // Only updates when the console is active
  if (consoleActive) {
    console.update();
  }

  // Tracks fps twice per second
  if (frameCount % 30 == 0) fps = (int)frameRate;
}

void keyPressed() {
  // Activates and deactives the console by pressing SHIFT C or pressing higher-case C
  if (consoleActive) console.getInput();
  if (key == 'C') {
    if (consoleActive) {
      consoleActive = false;
      typing = "";
    } else if (!consoleActive) consoleActive = true;
  }

  // Tracks what movement command the player has input
  switch(keyCode) {
  case 37: // left
    left = true;
    break;
  case 38: // up
    up = true;
    break;
  case 39: // right
    right = true;
    break;
  case 40: // down
    down = true;
    break;
  }
}

void keyReleased() {
  switch(keyCode) {
  case 37: // left
    left = false;
    break;
  case 38: // up
    up = false;
    break;
  case 39: // right
    right = false;
    break;
  case 40: // down
    down = false;
    break;
  }
}
