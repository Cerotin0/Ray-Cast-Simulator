class UI {
  // This whole class is in charge of the UI for this project
  float panelY = 120; // How far we want the panel to be from the bottom

  UI() {
    // Make sure you set the panel in here, rather than before
    panelY = height-panelY;
  }

  void Logic() {
    stroke(0);
    // Draw background for the ui panel
    beginShape();
    texture(uiBG);
    tint(200);
    vertex(-1, panelY, 0, 0);
    vertex(width+1, panelY, 1, 0);
    vertex(width+1, height+1, 1, 1);
    vertex(-1, height+1, 0, 1);
    endShape();

    // Draws a panel for the terminal
    if (consoleActive) {
      fill(40);
      rect(0, panelY, 230, height);
    } else {
      fill(0);
      text("Show/Hide terminal (SHIFT C)", 10, panelY+10, 100, 100);
    }

    // Shows user input if debugmode is activated
    if (debugmode) {
      if (nightmode) fill(255);
      else fill(0);
      text("left : " + left, 20, 20);
      text("right : " + right, 20, 40);
      text("up : " + up, 20, 60);
      text("down : " + down, 20, 80);
    }

    // Lights up if the the raycast has hit anything (bottom right)
    fill(230);
    text("Object", width-130, panelY+100);
    text("Detected:", width-130, panelY+115);
    fill(255, 0, 0);
    stroke(0);
    if (ray.rayDetected  == true) {
      fill(0, 255, 0);
    }
    ray.rayDetected = false;
    //ellipse(width-25, panelY+100, 30, 30);
    rect(width-40, panelY+85, 30, 30);

    // Shows fps and current test subject
    if (nightmode)fill(255);
    else fill(0);
    text("FPS: " + fps, width - 70, 20);
    text("Test Subject #" + testSubject, width-200, 40);

    // Shows score
    fill(120);
    text("Score: " + coin.score, width-200, 20);
    fill(230, 230, 0);
    text("Score: " + coin.score, width-200, 21);

    // Shows stuff that can be manipulated through the console
    fill(230, 200, 0);
    textFont(f);
    text("-------PLAYER-------", 240, panelY+20);
    fill(200);
    textFont(uif);
    text("px: " + nf(p.x, 0, -1), 240, panelY+35);
    text("py: " + nf(p.y, 0, -1), 330, panelY+35);
    text("prot       : " + nf(degrees(p.r), 0, -1), 240, panelY+50);
    text("protspeed  : " + nf(p.rotationSpeed*100, 0, 0), 240, panelY+65);
    text("pspeed     : " + nf(p.maxSpeed, 0, 0), 240, panelY+80);
    text("psteps     : " + nf(p.subSteps, 0, 0), 240, panelY+95);
    text("psize      : " + nf(p.w, 0, 0), 240, panelY+110);

    fill(230, 200, 0);
    textFont(f);
    text("--------RAYCAST--------", 440, panelY+20);
    fill(200);
    textFont(uif);
    text("raycast      : " + raycast, 440, panelY+35);
    text("raylen       : " + nf(ray.len, 0, 0), 440, panelY+50);
    text("rayangle     : " + nf(ray.rayAngle, 0, 0), 440, panelY+65);
    text("raycount     : " + nf(ray.rayCount, 0, 0), 440, panelY+80);
    text("raysteps     : " + nf(ray.subDivide, 0, 0), 440, panelY+95);
    text("rayshowlines : " + rayShowLines, 440, panelY+110);

    fill(230, 200, 0);
    textFont(f);
    text("-----RECTANGLES-----", 660, panelY+20);
    fill(200);
    textFont(uif);
    text("rectcount    : " + rectCount, 660, panelY+35);
    text("rectsize     : " + nf(rectSize, 0, 0), 660, panelY+50);
    text("rectvariance : " + nf(rectVariance, 0, 0), 660, panelY+65);
    text("rectshuffle", 660, panelY+80);

    fill(230, 200, 0);
    textFont(f);
    text("--------TRAPS--------", 880, panelY+20);
    fill(200);
    textFont(uif);
    text("trapcount    : " + trapCount, 880, panelY+35);
    text("trapsize     : " + nf(trapSize, 0, 0), 880, panelY+50);
    text("trapvariance : " + nf(trapVariance, 0, 0), 880, panelY+65);
    text("trapshuffle", 880, panelY+80);

    fill(230, 200, 0);
    textFont(f);
    text("-------FUN STUFF-------", 1090, panelY+20);
    fill(200);
    textFont(uif);
    text("nightmode    : " + nightmode, 1090, panelY+35);
    text("debugmode    : " + debugmode, 1090, panelY+50);
    text("showoutlines : " + showOutlines, 1090, panelY+65);
    text("help", 1090, panelY+80);
    text("score", 1090, panelY+95);

    text("count", 660, panelY+105);
    text("variance", 740, panelY+105);
    text("size", 880, panelY+105);
    text("shuffle", 960, panelY+105);

    // Resets the font back to general one
    textFont(f);
  }
}
