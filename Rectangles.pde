public class Rectangles {
  float x, y, w, h;
  color col;
  
  Rectangles() {
    x = random(-20, width-20);
    y = random(-20, height-120-20);
    w = abs(rectSize+random(-rectVariance, rectVariance));
    h = abs(rectSize+random(-rectVariance, rectVariance));
    col = color((int)random(0, 255), (int)random(0, 255), (int)random(0, 255));
  }

  void update() {
    fill(col, 100);
    strokeWeight(3);
    if (nightmode) fill(0);
    if(showOutlines) stroke(col);
    else noStroke();
    rect(x, y, w, h);
    strokeWeight(2);
    //ellipse(x+w/2, y+h/2, w, h); // Draws a circle around the centre of the rectangle

    // Checks if the coin spawned inside the rectangle
    if (sqrt(pow((coin.x-(x+w/2)), 2) + pow((coin.y-(y+h/2)), 2)) < (coin.s/2+w/2)) {
      coin.spawn();
    }
  }

  void V2ColAlgo(PVector vec) {
    // This algorithm checks if any of the players subdivided points are inside the rectangle
    if ((vec.x > x) && (vec.x < x+(w/5)) && (vec.y > y) && (vec.y < y+h)) {
      p.x -= 3;
    }
    if ((vec.x > x) && (vec.x < x+w) && (vec.y > y) && (vec.y < y+h/5)) {
      p.y -= 3;
    }
    if ((vec.x > x+(w*.8)) && (vec.x < x+w) && (vec.y > y) && (vec.y < y+h)) {
      p.x += 3;
    }
    if ((vec.x > x) && (vec.x < (x+w)) && (vec.y > y+(h*.8)) && (vec.y < y+h)) {
      p.y += 3;
    }
  }
}
