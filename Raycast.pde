public class Raycast {
  float x, y = 0; // origin
  float len = 0; // raycast length
  float startX, endX, startY, endY; // Stores the starting and ending pos of raycast
  float subDivide = 20; // How many times to divide the raycast length... higher = more accurate
  boolean rayDetected = false;
  boolean stopPos, stopNeg, stopMid = false; // Used for optimizing.. and to only show 3 rays

  float rayCount = 50; // How many rays should be shot out from the player.. higher = more accurate
  float rayAngle = 45;
  Raycast() {
    x = p.x;
    y = p.y;
    len = 400;
  }

  void display() {
    // Logic to manipulate the raycast
    // Rotates the raycast to match robots orientation and stores them
    startX = ((p.x) + cos(p.r))+((p.w/2)*cos(p.r));
    startY = (p.y) + sin(p.r)+((p.h/2)*sin(p.r));
    endX = startX + cos(p.r)*(len-20);
    endY = startY + sin(p.r)*(len-20);

    float endXpos = startX + cos(p.r+(radians(rayAngle/2)))*(len-20);
    float endYpos = startY + sin(p.r+(radians(rayAngle/2)))*(len-20);
    float endXneg = startX + cos(p.r-(radians(rayAngle/2)))*(len-20);
    float endYneg = startY + sin(p.r-(radians(rayAngle/2)))*(len-20);

    // Displays a faint outline of the middle/min/max raycast
    if (nightmode) stroke(200, 0, 0, 100);
    else stroke(200, 0, 0, 20);
    strokeWeight(2);
    if (rayShowLines) {
      line(startX, startY, endX, endY);
      line(startX, startY, endXpos, endYpos);
      line(startX, startY, endXneg, endYneg);
    }
    stroke(100, 0, 200);

    CalculateRaycast();
  }

  void CalculateRaycast() {
    // Divides a ray into subDivide amount of times
    for (float i = 1/ray.subDivide; i <= 1.01; i += 1/ray.subDivide) {
      float endingXpos = 0;
      float endingYpos = 0;
      float endingXneg = 0;
      float endingYneg = 0;

      // Checks if these points are inside any of the rectangles that we've spawned
      for (int rc = 0; rc < recs.length; rc++) {
        // Optimization: checks if the raycast len is within the rectangle, if no then stop here
        if (sqrt(pow((startX-(recs[rc].x+recs[rc].w/2)), 2) + pow((startY-(recs[rc].y+recs[rc].h/2)), 2)) < (ray.len+recs[rc].w/2)) {
          if (rayCount > 0 && stopMid == false) {
            // Checks if the middle raycast is colliding with any rectangles
            if (ray.startX+cos(p.r)*((ray.len-20)*i) > recs[rc].x && ray.startX+cos(p.r)*((ray.len-20)*i) < (recs[rc].x+recs[rc].w)
              && (ray.startY+sin(p.r)*(ray.len-20)*i) > recs[rc].y && ray.startY+sin(p.r)*((ray.len-20)*i) < (recs[rc].y+recs[rc].h))
            {
              fill(100, 40);
              stroke(0, 230, 0);
              line(ray.startX, ray.startY, ray.startX+cos(p.r)*((ray.len-20)*i), ray.startY+sin(p.r)*((ray.len-20)*i));
              ray.rayDetected = true;
              stopMid = true;
              //return;
            }
          }

          for (float b = (ray.rayAngle)/ray.rayCount; b < ray.rayAngle/2 + 0.01; b += (ray.rayAngle)/ray.rayCount) {
            endingXpos = ray.startX + cos(p.r+radians(b))*(ray.len-20)*i;
            endingYpos = ray.startY + sin(p.r+radians(b))*(ray.len-20)*i;
            endingXneg = ray.startX + cos(p.r-radians(b))*(ray.len-20)*i;
            endingYneg = ray.startY + sin(p.r-radians(b))*(ray.len-20)*i;

            // Checks for any raycasts colliding with rectangles
            if (stopPos == false && (endingXpos > recs[rc].x && endingXpos < recs[rc].x+recs[rc].w)
              && (endingYpos > recs[rc].y && endingYpos < recs[rc].y+recs[rc].h)) {
              stroke(0, 230, 0);
              line(ray.startX, ray.startY, endingXpos, endingYpos);
              ray.rayDetected = true;
              stopPos = true;
              //return;
            } else if (stopNeg == false && (endingXneg > recs[rc].x && endingXneg < recs[rc].x+recs[rc].w)
              && (endingYneg > recs[rc].y && endingYneg < recs[rc].y+recs[rc].h)) {
              stroke(0, 230, 0);
              line(ray.startX, ray.startY, endingXneg, endingYneg);
              ray.rayDetected = true;
              stopNeg = true;
              //return;
            }
          }
        }
      }
      
      // Checks if these points are inside any of the traps that we've spawned
      for (int tc = 0; tc < traps.length; tc++) {
        // Optimization: checks if the raycast len is within the traps, if no then stop here
        if (sqrt(pow((startX-(traps[tc].x+traps[tc].w/2)), 2) + pow((startY-(traps[tc].y+traps[tc].h/2)), 2)) < (ray.len+traps[tc].w/2)) {
          if (rayCount > 0 && stopMid == false) {
            // Checks if the middle raycast is colliding with any traps
            if (ray.startX+cos(p.r)*((ray.len-20)*i) > traps[tc].x && ray.startX+cos(p.r)*((ray.len-20)*i) < (traps[tc].x+traps[tc].w)
              && (ray.startY+sin(p.r)*(ray.len-20)*i) > traps[tc].y && ray.startY+sin(p.r)*((ray.len-20)*i) < (traps[tc].y+traps[tc].h))
            {
              fill(100, 40);
              stroke(230, 0, 0, 200);
              line(ray.startX, ray.startY, ray.startX+cos(p.r)*((ray.len-20)*i), ray.startY+sin(p.r)*((ray.len-20)*i));
              ray.rayDetected = true;
              stopMid = true;
              //return;
            }
          }

          for (float b = (ray.rayAngle)/ray.rayCount; b < ray.rayAngle/2 + 0.01; b += (ray.rayAngle)/ray.rayCount) {
            endingXpos = ray.startX + cos(p.r+radians(b))*(ray.len-20)*i;
            endingYpos = ray.startY + sin(p.r+radians(b))*(ray.len-20)*i;
            endingXneg = ray.startX + cos(p.r-radians(b))*(ray.len-20)*i;
            endingYneg = ray.startY + sin(p.r-radians(b))*(ray.len-20)*i;

            // Checks for any raycasts colliding with traps
            if (stopPos == false && (endingXpos > traps[tc].x && endingXpos < traps[tc].x+traps[tc].w)
              && (endingYpos > traps[tc].y && endingYpos < traps[tc].y+traps[tc].h)) {
              stroke(230, 0, 0);
              line(ray.startX, ray.startY, endingXpos, endingYpos);
              ray.rayDetected = true;
              stopPos = true;
              //return;
            } else if (stopNeg == false && (endingXneg > traps[tc].x && endingXneg < traps[tc].x+traps[tc].w)
              && (endingYneg > traps[tc].y && endingYneg < traps[tc].y+traps[tc].h)) {
              stroke(230, 0, 0);
              line(ray.startX, ray.startY, endingXneg, endingYneg);
              ray.rayDetected = true;
              stopNeg = true;
              //return;
            }
          }
        }
      }
    }

    // Resets these to false to show the all rays (once per loop)
    stopPos = false;
    stopNeg = false;
    stopMid = false;
  }
}
