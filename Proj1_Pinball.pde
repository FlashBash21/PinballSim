
int numCircles;
int numObs;
int numLines;
int numBLines;
int numZones = 1;
int score = 0;
float cd = 0.05f;
float tr_time = 0.10f;

//Gravity Vector
Vec2 gravity = new Vec2(0,5);

float r = 15;
float b_coeff = -0.85;

//Inital positions and velocities of balls
Vec2 pos[];
Vec2 vel[];

//Line segment positions
Vec2 line_pos1[];
Vec2 line_pos2[];

Vec2 bline_pos1[];
Vec2 bline_pos2[];

boolean tr_bline[];
float tr_bline_timer[];

//Circle obstacle positions
Vec2 obs_pos[];
float obs_r[];

//fail zones
Vec2 zone_pos[];
Vec2 zone_dim[];
int zone_score[];
float score_cd[];


//InputParser
InputParser parser;
ParticleGenerator explosions[];

void setup(){
  size(1200,600);
  surface.setTitle("Pinball Sim");
  //seed off systime
  randomSeed(second() * minute());
  
  //parse the board layout
  parser = new InputParser("layout1");
   
  //pull info from the parser
  numCircles = parser.getNumBalls();
  numLines = parser.getNumLines();
  numBLines = parser.getNumBLines();
  numObs = parser.getNumObs();
  numZones = parser.getNumZones();
  
  
  pos = new Vec2[numCircles];
  vel = new Vec2[numCircles];
  explosions = new ParticleGenerator[numCircles];
  
  
  //Initial ball positions and velocities
  for (int i = 0; i < numCircles; i++){
    pos[i] = new Vec2(width/2 + random(-200, 200),height/16);
    vel[i] = new Vec2(random(100),100+random(20)); 
  }
  
  //pull object data from the parser
  line_pos1 = parser.getLinePos1();
  line_pos2 = parser.getLinePos2();
  
  bline_pos1 = parser.getBLinePos1();
  bline_pos2 = parser.getBlinePos2();
  tr_bline = new boolean[numBLines];
  tr_bline_timer = new float[numBLines];
  
  for (int i = 0; i < numBLines; i++) {
    tr_bline[i] = false;
  }
  
  obs_pos = parser.getObsPos();
  obs_r = parser.getObsR();
  
  zone_pos = parser.getZonePos();
  zone_dim = parser.getZoneDim();
  zone_score = parser.getZoneScore();
  score_cd = new float[numZones];
  
  strokeWeight(2); //Draw thicker lines 
}

void update(float dt){
  for (int i = 0; i < numCircles; i++){
    vel[i].add(gravity);
    pos[i].add(vel[i].times(dt));
    
    //check collisions with zones
    for(int j = 0; j < numZones; j++) {
      if(boxWithCircle(pos[i], r, zone_pos[j], zone_dim[j])) {
        if (zone_score[j] < 0) {
          explosions[i] = new ParticleGenerator(20, 200, 0.5f, pos[i]);
          
          //KILL the ball
          Vec2 temp_pos = pos[numCircles-1];
          Vec2 temp_vel = vel[numCircles-1];
          pos[i] = temp_pos;
          vel[i] = temp_vel;
          numCircles--;
        } else {
          if (score_cd[j] <= 0) {
            score += zone_score[j];
            score_cd[j] = cd;
          }
        }
        
      }
    }
    
    //check collisions with circles
    for(int j = 0; j < numObs; j++) {
      if (circleWithCircle(pos[i], obs_pos[j], r, obs_r[j])) {
        
        //circle bounce
        Vec2 normal = (pos[i].minus(obs_pos[j])).normalized();
        pos[i] = obs_pos[j].plus(normal.times(obs_r[j]+r).times(1.01));
        Vec2 velNormal = normal.times(dot(vel[i], normal));
        vel[i].subtract(velNormal.times(1.8));
        break; //one collision per frame, don't need to check the rest
      }
    }
    
    for(int j = 0; j < numCircles; j++) {
      if (j != i && circleWithCircle(pos[i], pos[j], r, r)) {
        Vec2 normal = (pos[i].minus(pos[j])).normalized();
        pos[i] = pos[j].plus(normal.times(r+r).times(1.01));
        Vec2 velNormal = normal.times(dot(vel[i], normal));
        vel[i].subtract(velNormal.times(1.8));
      }
    }
    
    //line bounce
    for(int j = 0; j < numLines; j++) {
      if (circleWithLine(pos[i], r, line_pos1[j], line_pos2[j])) {
        Vec2 line_normal = lineSegNormal(line_pos1[j], line_pos2[j]);
        
        //hack the position to prevent clipping

        //make sure we are hacking in the right direction
        if (sameSide(line_pos1[j], line_pos2[j], line_normal, pos[i])) line_normal.mul(-1);        
        pos[i].add(line_normal.times(r/3));
        
        //update velocity
        Vec2 b = line_normal.times(dot(vel[i], line_normal));
        vel[i].subtract(b.times(2));
        vel[i].mul(-1 * b_coeff);
        
        break;
      }
    }
    
    //bouncy lines
    for(int j = 0; j < numBLines; j++) {
      if (circleWithLine(pos[i], r, bline_pos1[j], bline_pos2[j])) {
        Vec2 line_normal = lineSegNormal(bline_pos1[j], bline_pos2[j]);
        
        //hack the position to prevent clipping

        //make sure we are hacking in the right direction
        if (sameSide(bline_pos1[j], bline_pos2[j], line_normal, pos[i])) line_normal.mul(-1);        
        pos[i].add(line_normal.times(r/3));
        
        //update velocity
        Vec2 b = line_normal.times(dot(vel[i], line_normal));
        vel[i].subtract(b.times(2));
        vel[i].mul(1.5);
        
        tr_bline[j] = true;
        tr_bline_timer[j] = tr_time;
        
        break;
      }
    }
    
    //in case the balls escape, keep them within the bounds
    if (pos[i].y > height - r){
      pos[i].y = height - r;
      vel[i].y += 10;
      vel[i].y *= b_coeff;
    }
    if (pos[i].y < r){
      pos[i].y = r;
      vel[i].y *= b_coeff;
    }
    if (pos[i].x > width - r){
      pos[i].x = width - r;
      vel[i].x *= b_coeff;
    }
    if (pos[i].x < r){
      pos[i].x = r;
      vel[i].x *= b_coeff;
    }
    
  }
}


void draw(){
  update(1.0/frameRate);
  
  background(100);
  stroke(0,0,0);
  fill(10,120,10);
  
  //draw zones
  fill(100, 0, 0);
  stroke(0,0,0);
  for (int i = 0; i < numZones; i++) {
    if (zone_score[i] < 0) fill(100,0,0);
    else fill(0,255,0);
    
    if (score_cd[i] > 0) score_cd[i] -= 1/frameRate;
    
    rect(zone_pos[i].x - zone_dim[i].x/2, zone_pos[i].y - zone_dim[i].y/2, zone_dim[i].x, zone_dim[i].y);
  }
  
  
  //draw balls
  fill(100, 0, 100);
  for (int i = 0; i < numCircles; i++){
    circle(pos[i].x, pos[i].y, r*2); 
  }
  
  //draw obs
  fill(0, 0, 255);
  for (int i = 0; i < numObs; i++) {
    circle(obs_pos[i].x, obs_pos[i].y, obs_r[i]*2);
  }
  
  //draw lines
  for (int i=0; i < numLines; i++) {
    line(line_pos1[i].x, line_pos1[i].y, line_pos2[i].x, line_pos2[i].y);
  }
  
  //draw bouncy lines
  stroke(255,0,0);
  for (int i=0; i < numBLines; i++) {
    if (tr_bline[i]) {
      stroke(255,100,0);
      tr_bline_timer[i] -= 1/frameRate;
      if (tr_bline_timer[i] < 0) tr_bline[i] = false;
    } else {
      stroke(255,0,0);
    }
    line(bline_pos1[i].x, bline_pos1[i].y, bline_pos2[i].x, bline_pos2[i].y);
  }
  
  fill(255, 255, 100);
  strokeWeight(0);
  for (ParticleGenerator i : explosions) if (i != null) i.drawExplosion(1/frameRate);
  strokeWeight(2); //reset line thickness
  
  textSize(50);
  text("Score: " + score, width / 32, height / 16);
  //circle(spherePos.x, spherePos.y, sphereRadius*2);
}





//Collision code adapted from my Homework 1 sollutions to use arrays of vectors instead of arrays of objects, to increase performance


//circle-circle collision
public boolean circleWithCircle(Vec2 c1_pos, Vec2 c2_pos, float c1_r, float c2_r) {
  return c1_pos.distanceTo(c2_pos) <= c1_r + c2_r;
}

//circle-line collision
public boolean circleWithLine(Vec2 c_pos, float r, Vec2 l_pos1, Vec2 l_pos2) {
  Vec2 toCircle = c_pos.minus(l_pos1);
  Vec2 l_dir = l_pos2.minus(l_pos1);
  float l_len = l_dir.length();
  l_dir.normalize();

  float a = 1; //length of line
  float b = -2*dot(l_dir, toCircle); //-2*dot(l_dir,toCircle)
  float c = toCircle.lengthSqr() - r*r; //different of squared distances

  float d = b*b - 4*a*c;

  if (d >= 0) {
    float t1 = (-b - sqrt(d))/(2*a); //Optimization: we only take the first collision [is this safe?]
    float t2 = (-b + sqrt(d))/(2*a); //check the second point of collision

    if (t1 > 0 && t1 < l_len) { //line starts outside circle
      return true;
    } else if (t2 > 0 && t2 < l_len) { //line starts inside circle
      return true;
    } else if (t1 < 0 && t2 > 1) { //line is completely inside circle
      return true;
    }
  }

  return false;
}

//circle box collision
public boolean boxWithCircle(Vec2 c_pos, float c_r, Vec2 b_pos, Vec2 b_dim) {
  Vec2 closest = new Vec2(
    constrain(c_pos.x, b_pos.x - b_dim.x/2, b_pos.x + b_dim.x/2),
    constrain(c_pos.y, b_pos.y - b_dim.y/2, b_pos.y + b_dim.y/2)
    );

  return closest.minus(c_pos).length() < c_r;
}

public boolean sameSide(Vec2 line_p1, Vec2 line_p2, Vec2 pos1, Vec2 pos2) {
  float cp1 = cross(line_p2.minus(line_p1), pos1.minus(line_p1));
  float cp2 = cross(line_p2.minus(line_p1), pos2.minus(line_p1));
  return cp1*cp2 >= 0;
}

//returns normalized normal of a line segment
public Vec2 lineSegNormal(Vec2 pos1, Vec2 pos2) {
  float dx = pos1.x - pos2.x;
  float dy = pos1.y - pos2.y;
  Vec2 normal = new Vec2(-dy, dx);
  return normal.normalized();
}
