public class Player {
  float x, y, r, w, h, rotationSpeed;
  float maxSpeed;

  float subSteps = 5; // How many times players edges should be subdivded... more = more accurate
  PVector TL, TR, BR, BL;

  // Give the player a brief period of invicibilty after they touch a trap, to preven the player
  // from dying 30 times before getting teleported somewhere else
  boolean invincible = false;

  // NOTE: robots spawns facing right, therefore the angle when facing positive x axis is 0
  Player() {
    x = width/2;   // Robots starting pos
    y = height/2;  // Robots starting pos
    w = 45;        // Robots width
    h = 45;        // Robots height
    r = radians(0);
    maxSpeed = 5;  // Set's robots speed
    rotationSpeed = 0.06; // Set's robots rotation speed
  }

  void update() {
    subdivide();
    // Rotates the robot left and right
    if (left) r -= rotationSpeed;
    if (right) r += rotationSpeed;

    // Moves the robot back and forth
    if (up) forward();
    if (down) backward();

    checkBound(); // Loops the robot when they exit out of bounds
    if (abs(r) > TWO_PI) r = 0; // Simply loops the rotation back to 0 if we go TWO_PI
  }

  void display() {
    //pushMatrix();
    //translate (x, y);
    //rotate(r);                     // Displays the robot rotating
    //if (nightmode) {stroke(230); fill(140,100);}
    //else {stroke(0); fill(100,100);}
    ////fill(0, 200, 20);
    ////noFill();
    //strokeWeight(2);
    //rect(0 - w/2, 0 - h/2, w, h);  // ROBOT BODY
    //fill(240, 200, 0);
    //ellipse(0+h/2, 0, 10, 10);        // ROBOT EYE
    //popMatrix();

    //Draw player texture
    beginShape();
    noStroke();
    texture(playerImg);
    if (nightmode) tint(100);
    else tint(255);
    vertex(TL.x, TL.y, 0, 0);
    vertex(TR.x, TR.y, 1, 0);
    vertex(BR.x, BR.y, 1, 1);
    vertex(BL.x, BL.y, 0, 1);
    endShape();
  }

  void checkBound() {
    if (x>width) x = -w;
    if (x < -w) x = width;
    if (y > height-120) y = -h;
    if (y < -h) y = height-120;
  }

  void forward() {
    // Takes care of forward movement
    x += cos(r) * maxSpeed;
    y += sin(r) * maxSpeed;
  }

  void backward() {
    // Takes care of backwards movement
    x += cos(r) * -maxSpeed;
    y += sin(r) * -maxSpeed;
  }

  void subdivide() {
    // This part calculated TopLeft TopRight BotRight BotLeft XY using the players rotation and
    // stores the values in PVectors to enable more complex hitbox collisions
    // Top Left
    TL = new PVector(x - (w/2*cos(p.r)) + (w/2*sin(p.r)),
      y - (h/2*sin(p.r) + (h/2*cos(p.r))));
    // Top Right
    TR = new PVector(x + (w/2*cos(p.r)) + (w/2*sin(p.r)),
      y - (h/2*cos(p.r) - (h/2*sin(p.r))));
    // Bot Right
    BR = new PVector(x + w/2*cos(p.r) - (w/2*sin(p.r)),
      y + ((h/2*sin(p.r)) + (h/2*cos(p.r))));
    // Bot Left
    BL = new PVector(x - w/2*cos(p.r) - (w/2*sin(p.r)),
      y - ((h/2*sin(p.r)) - (h/2*cos(p.r))));

    for (float i = w/subSteps; i < w+0.01; i+= w/subSteps) {
      // This adds points along the players edges, and checks whether they're inside this rectangle
      PVector E1 = new PVector(lerp(p.TL.x, p.TR.x, i/w), lerp(p.TL.y, p.TR.y, i/w));
      PVector E2 = new PVector(lerp(p.TR.x, p.BR.x, i/w), lerp(p.TR.y, p.BR.y, i/w));
      PVector E3 = new PVector(lerp(p.BR.x, p.BL.x, i/w), lerp(p.BR.y, p.BL.y, i/w));
      PVector E4 = new PVector(lerp(p.BL.x, p.TL.x, i/w), lerp(p.BL.y, p.TL.y, i/w));

      // Draws the points on edges
      if (debugmode) {
        float s = 5;
        noFill();
        stroke(255, 0, 0);
        ellipse(E1.x, E1.y, s, s);
        stroke(0, 255, 0);
        ellipse(E2.x, E2.y, s, s);
        stroke(0, 0, 255);
        ellipse(E3.x, E3.y, s, s);
        stroke(220, 220, 0);
        ellipse(E4.x, E4.y, s, s);
      }

      // Run all these points through the collision detection algo
      // The algorithm checks if any of these points are inside the rectangle
      for (int recLoc = 0; recLoc < recs.length; recLoc++) {
        recs[recLoc].V2ColAlgo(E1);
        recs[recLoc].V2ColAlgo(E2);
        recs[recLoc].V2ColAlgo(E3);
        recs[recLoc].V2ColAlgo(E4);
      }

      // Run all these points through the collision detection algo
      // The algorithm checks if any of these points are inside the trap
      for (int trapLoc = 0; trapLoc < traps.length; trapLoc++) {
        if (!invincible) {
          traps[trapLoc].V2ColAlgo(E1);
          traps[trapLoc].V2ColAlgo(E2);
          traps[trapLoc].V2ColAlgo(E3);
          traps[trapLoc].V2ColAlgo(E4);
        }
      }
    }
    invincible = false;
  }
}
