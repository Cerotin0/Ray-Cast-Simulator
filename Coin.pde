class Coin{
  int score = 0;
  int highestScore = 0; // Used to store the highest score when the player dies
  int x, y = 0;
  float s = 20;         // Size of the coin
  float d = 0;          // Distance between coin and player
  float combR;          // Combined radius between coin and player
  
  // Parameters for creating a "breathing" effect on the coin
  float easing = 0.02;
  float time = 0;
  boolean change = false;
  
  void spawn(){
    x = (int)random(0+39, width-30);
    y = (int)random(0+30, height-30-120); // 120 is the size of the bottom panel
  }
  
  void display(){
    // Gives the coin a "breathing" effect
    if(change == false){
    time += easing;
    if(time>1) change=true;
    } else if(change == true) {
      time -= easing;
      if(time <0) change=false;
    }
    float a = lerp(200,255,time); // lerps between those two points
    fill(a,a,0);
    stroke(0);
    ellipse(x,y,s,s);
    
    d = sqrt(pow((x-p.x),2) + pow((y-p.y),2)); // Calculates distance between coin and player
    combR = (s+p.w)/2; // Calculates the combined radius of player and coin
    
    // If distance is less than combined radius, then add 1 to score aand tp the coin somewhere else
    if(d < (combR)){
      score++;
      spawn();
    }
  }
}
