// Reference used: http://learningprocessing.com/examples/chp18/example-18-01-userinput

// Console used by the user, can be activated/deactivated by pressing SHIFT C
// (or really by hitting higher case C)
String typing = "";
String saved = "";
boolean consoleActive = false;

class Console {
  boolean error = false;

  void update() {
    fill(255);
    if (consoleActive) {
      // Display input and saved ui
      text("Input: ", 10, ui.panelY+20);
      text(typing, 65, ui.panelY+1, 165, 30);
      fill(0, 200, 0);
      if (error == true) fill(230, 0, 0);
      text(saved, 10, ui.panelY+30, 220, 100);
    }
  }

  void getInput() {
    if (consoleActive) {
      if (key == '\n' ) {
        saved = typing;
        typing = "";
        Command(saved);
      } else {
        if (keyCode == BACKSPACE) {
          // Deletes previous char
          if (typing.length() > 0) typing = typing.substring(0, typing.length()-1);
        } else if (key == 46 && error == false) {
          // If '.' is pressed, we can return the last command used
          typing = saved;
        } else if ((key >= 48 && key <= 57)||(key >= 97 && key <= 122) || key == 32) {
          typing = typing + key;
        }
      }
    }
  }

  void Command(String input) {
    // Divides the string into its components
    String command = new String("");
    String value = new String("");
    int stage = 0; //            0 = command         1 = value

    // Goes through the users input and divides it into 2 parts; command and value,
    // seperated by a space. This also checks if there are more than just 2 parts, if so,
    // then return an error and stop executing
    for (int i = 0; i < input.length(); i++) {
      // Check if theres a space
      if (input.charAt(i) == ' ') {
        stage++;
      } else {
        if (stage == 0) {
          command += input.charAt(i);
        } else if (stage == 1) {
          value += input.charAt(i);
        } else if (stage > 1) {
          saved = "ERROR: one COMMAND (& max one VALUE only)";
          error = true;
          return;
        }
      }
    }

    // If the input is valid (1 or 2 words) then it goes through the command list in Execute()
    // If the user only enters the command (eg. debugmode) we assign value to 0 to prevent any errors
    if (value.length() == 0) value = "0";
    Execute(command, value);
  }

  void Execute(String command, String _value) {
    int value = 0;
    // Checks to make sure every char in value is numeric
    for (int i = 0; i < _value.length(); i++) {
      if (int(_value.charAt(i)) < 48 || int(_value.charAt(i)) > 57) {
        saved = "ERROR: value not numeric";
        error = true;
        return;
      }
    }

    // Since integers have a limited size, this prevents the user from 'overflowing' it, it also
    // stops the user from going above 10k because realistically unless you want to put 1000000
    //into raysteps and turn your computer into a jet engine, you probably shouldn't
    // be going over 10k in anything
    try {
      value = Integer.valueOf(_value);
    }
    catch (Exception e) {
      value = 10000;
    }
    if (value > 10000) value = 10000;

    // If we encounter an error with user input later on, make sure to reset it to false
    // before running this loop again
    error = false;
    // Checks if the input command is valid
    switch(command) {
      // Player manipulation
    case "px":
      p.x = value;
      break;
    case "py":
      p.y = value;
      break;
    case "pspeed":
      p.maxSpeed = value;
      break;
    case "psize":
      if (value == 0) value = 1;
      p.w = value;
      p.h = value;
      break;
    case "protspeed":
      p.rotationSpeed = value*0.01;
      break;
    case "prot":
      p.r = radians(value);
      break;
    case "psteps":
      p.subSteps = value;
      break;

      // Ray manipulation
    case "raylen":
      ray.len = value;
      break;
    case "raycount":
      if (value > 10000) value = 10000;
      ray.rayCount = value;
      break;
    case "rayangle":
      if (value < 2) value = 2;
      ray.rayAngle = value;
      break;
    case "raysteps":
      ray.subDivide = value;
      break;
    case "rayshowlines":
      if (rayShowLines) rayShowLines = false;
      else rayShowLines = true;
      break;
    case "raycast":
      if (raycast) raycast = false;
      else raycast = true;
      break;

      // Rectangle manipulation
    case "rectcount":
      rectCount = value;
      recs = new Rectangles[value];
      for (int i = 0; i < recs.length; i++) {
        recs[i] = new Rectangles();
      }
      break;
    case "rectsize":
      rectSize = value;
      for (int i = 0; i < recs.length; i++) {
        recs[i].h = value;
        recs[i].w = value;
      }
      break;
    case "rectshuffle":
      for (int i = 0; i < recs.length; i++) {
        recs[i] = new Rectangles();
      }
      break;
    case "rectvariance":
      rectVariance = value;
      for (int i = 0; i < recs.length; i++) {
        recs[i].w += random(-rectVariance, rectVariance);
        recs[i].h += random(-rectVariance, rectVariance);
      }
      break;

      // Trap manipulation
    case "trapcount":
      trapCount = value;
      traps = new Traps[value];
      for (int i = 0; i < traps.length; i++) {
        traps[i] = new Traps();
      }
      break;
    case "trapsize":
      trapSize = value;
      for (int i = 0; i < traps.length; i++) {
        traps[i].h = value;
        traps[i].w = value;
      }
      break;
    case "trapvariance":
      trapVariance = value;
      for (int i = 0; i < traps.length; i++) {
        traps[i].w += random(-trapVariance, trapVariance);
        traps[i].h += random(-trapVariance, trapVariance);
      }
      break;
    case "trapshuffle":
      for (int i = 0; i < traps.length; i++) {
        traps[i] = new Traps();
      }
      break;

      // Fun stuff
    case "nightmode":
      if (nightmode) {
        nightmode = false;
        showOutlines = true;
      } else {
        nightmode = true;
        showOutlines = false;
      }
      break;
    case "debugmode":
      if (debugmode) debugmode = false;
      else debugmode = true;
      break;
    case "help":
      //saved = "one COMMAND and one VALUE(if applicable) eg... px 10, debugmode";
      saved = "1 COMMAND + 1 VALUE (if applicable) eg.. [px 100], [debugmode]";
      break;
    case "score":
      saved = "Most valuable test subject is #" + mostValuableTestSubject + " with " +
        coin.highestScore + " points";
      break;

      // These commands affect both rectangles and traps
    case "showoutlines":
      if (showOutlines) showOutlines = false;
      else showOutlines = true;
      break;
    case "shuffle":
      for (int i = 0; i < traps.length; i++) {
        traps[i] = new Traps();
      }
      for (int i = 0; i < recs.length; i++) {
        recs[i] = new Rectangles();
      }
      break;
    case "size":
      trapSize = value;
      for (int i = 0; i < traps.length; i++) {
        traps[i].h = value;
        traps[i].w = value;
      }
      rectSize = value;
      for (int i = 0; i < recs.length; i++) {
        recs[i].h = value;
        recs[i].w = value;
      }
      break;
    case "variance":
      trapVariance = value;
      for (int i = 0; i < traps.length; i++) {
        traps[i].w += random(-trapVariance, trapVariance);
        traps[i].h += random(-trapVariance, trapVariance);
      }
      rectVariance = value;
      for (int i = 0; i < recs.length; i++) {
        recs[i].w += random(-rectVariance, rectVariance);
        recs[i].h += random(-rectVariance, rectVariance);
      }
      break;
    case "count":
      trapCount = round(value/2);
      traps = new Traps[round(value / 2)];
      for (int i = 0; i < traps.length; i++) {
        traps[i] = new Traps();
      }
      rectCount = round(value/2);
      recs = new Rectangles[round(value/2)];
      for (int i = 0; i < recs.length; i++) {
        recs[i] = new Rectangles();
      }
      break;

      // If user input doesn't match any command, throw this error out
    default:
      saved = "ERROR: Unknown Command";
      error = true;
      break;
    }
  }
}
