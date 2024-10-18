public class Traps {
  float x, y, w, h;

  Traps() {
    x = random(-20, width-20);
    y = random(-20, height-120-20);
    w = abs(trapSize+random(-trapVariance, trapVariance));
    h = abs(trapSize+random(-trapVariance, trapVariance));
  }

  void update() {
    strokeWeight(3);
    if (nightmode) fill(0);
    else fill(160, 0, 0, 100);
    if (showOutlines) {
      stroke(255, 0, 0);
      fill(160, 0, 0, 70);
    } else noStroke();
    rect(x, y, w, h);
    strokeWeight(2);
    //ellipse(x+w/2, y+h/2, w, h); // Draws a circle around the centre of the rectangle

    // Checks if the coin spawned inside the rectangle
    if (sqrt(pow((coin.x-(x+w/2)), 2) + pow((coin.y-(y+h/2)), 2)) < (coin.s/2+w/2)) {
      coin.spawn();
    }
  }

  void V2ColAlgo(PVector vec) {
    // This algorithm checks if any of the players subdivided points are inside the trap
    if ((vec.x > x) && (vec.x < x+(w/5)) && (vec.y > y) && (vec.y < y+h)) {
      subjectDead();
    } else if ((vec.x > x) && (vec.x < x+w) && (vec.y > y) && (vec.y < y+h/5)) {
      subjectDead();
    } else if ((vec.x > x+(w*.8)) && (vec.x < x+w) && (vec.y > y) && (vec.y < y+h)) {
      subjectDead();
    } else if ((vec.x > x) && (vec.x < (x+w)) && (vec.y > y+(h*.8)) && (vec.y < y+h)) {
      subjectDead();
    }
  }

  void subjectDead() {
    p.invincible = true;
    p.x = random(0, width);
    p.y = random(0, height);

    // Stores the highest score, and the test subject associated with the highest score
    if (coin.score > coin.highestScore) {
      coin.highestScore = coin.score;
      mostValuableTestSubject = testSubject;
    }
    testSubject++;
    coin.score = 0;
  }
}
