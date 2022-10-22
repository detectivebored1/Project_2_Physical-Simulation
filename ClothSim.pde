//ArrayList<PVector> points = new ArrayList<PVector>();
PVector[][] pointsArray;
PVector[][] velArray;
boolean[][] connected;
int width = 40;
int height = 60;
float spacing = 1;
float radius = 2;

float ks = 25; //Spring Damp
float kd = 10; // Vel Damp
float gravity = 10; 
boolean paused = true;
int limit = 5;

//Obstacle information
PVector obstaclePos;
PVector obstacleVel;
float obsRadius = 100;


//Info for drag
float fluid_density = 2; //p
float drag_coef = 3; //c_d
PVector vAir = new PVector(0,gravity,0);

PImage img;
Camera camera;
void setup()
{
  size(600, 600, P3D);
  camera = new Camera();
  img = loadImage("StrawHat.png");
  obstaclePos = new PVector(229.64078, 202.67903, 227.01591);
  pointsArray = new PVector[height][width];
  velArray = new PVector[height][width];
  connected = new boolean[height][width];

  

  for(int y = 0; y < height; y++){
    for(int x = 0; x < width; x++){
        connected[y][x] = true;
        pointsArray[y][x] = new PVector(x*spacing + 200,180,y*spacing+200);
        velArray[y][x] = new PVector(0,0,0);
    }     
  }

}

PVector calculateAirDrag(PVector p1, PVector p2, PVector p3,PVector v1, PVector v2, PVector v3){ // Calculates drag; Divide by three and add to appropriate velocities
  //drag = -(1/2) * density of fluid * |avg(p1.vel,p2.vel,p3.vel) - vel_air|^2 * drag coefficient * area * normal;
  PVector v = ((v1.add(v2).add(v3)).div(3)).sub(vAir); // Using gravity as v_air for now
  PVector n_star = (PVector.sub(p2,p1).cross(PVector.sub(p3,p1)));
  float numerator = (v.mag()) * (v.dot(n_star));
  float denominator = 2 * n_star.mag();

  PVector otherTerm = n_star.mult(numerator/denominator);

  PVector force = otherTerm.mult(-.5 * fluid_density * drag_coef);
  return force;
}

void update(float dt){
  PVector[][] velBuffer = velArray.clone();


  for(int y = 0; y < height;y++){ //Horizontal
    for(int x = 0; x < width-1;x++){
      PVector e = PVector.sub(pointsArray[y][x+1],pointsArray[y][x]);
      float length = (float) Math.sqrt(PVector.dot(e,e));
      if(length > limit*(spacing)){
        connected[y][x] = false;
        connected[y][x+1] = false;
      }
      e = e.div(length);

      float vel1 = PVector.dot(e,velArray[y][x]);
      float vel2 = PVector.dot(e,velArray[y][x+1]);

      float d2t = dt/2;

      float dampF = kd*(vel1 - vel2);
      float stringF = ks*(length - spacing);

      PVector force = e.mult(stringF+dampF);
              

      if(connected[y][x]){
        velBuffer[y][x+1] = velBuffer[y][x+1].sub(force.mult(d2t));
        velBuffer[y][x] = velBuffer[y][x].add(force.mult(d2t));
      }

    }
  }

  for(int y = 0; y < height -1;y++){ // Vertical
    for(int x = 0; x < width;x++){
      PVector e = PVector.sub(pointsArray[y+1][x],pointsArray[y][x]);
      float length = (float) Math.sqrt(PVector.dot(e,e));
      e = e.div(length);
      if(length > limit*(spacing)){
        connected[y][x] = false;
        connected[y+1][x] = false;
      }
      float vel1 = PVector.dot(e,velArray[y][x]);
      float vel2 = PVector.dot(e,velArray[y+1][x]);

      float d2t = dt/2;
      float dampF = kd*(vel1 - vel2);
      float stringF = ks*(length - spacing);
      //println(y+" " + x +" "+stringF);

      PVector force = e.mult(stringF+dampF);
              

      if(connected[y][x]){
        velBuffer[y+1][x] = velBuffer[y+1][x].sub(force.mult(d2t));
        velBuffer[y][x] = velBuffer[y][x].add(force.mult(d2t)); 
      }
    }
  }

  // for(int y = 0; y < height;y++){
  //   for(int x = 0; x < width;x++){
        
  //   }   
  // }

  for(int y = 0; y < height;y++){//Apply gravity
    for(int x = 0; x < width;x++){
      velBuffer[y][x].add(new PVector(0,gravity*dt,0));
    }
  }

  //for(int y = 0; y < height;y++){ // Fix Points
  //  velBuffer[y][0] = new PVector(0,0,0);
  //}


  velArray = velBuffer;
  for(int y = 0; y < height;y++){//Apply velocity & object collision
    for(int x = 0; x < width;x++){
      PVector point = pointsArray[y][x];
      if(point.dist(obstaclePos) <= obsRadius+radius){
        //This breaks the simulation
         //PVector normal = PVector.sub(point,obstaclePos).normalize();
         //PVector pVel = velArray[y][x]; 

         //PVector offset = PVector.add(point,normal.mult(obsRadius+radius).mult(1.01)); // New Position
         //pointsArray[y][x] = offset;

         ////println("Original: " + point + " Offset: " + offset);
         //PVector velNormal = PVector.mult(normal,PVector.dot(pVel,normal));
         //point = pointsArray[y][x];

         ////println("Normal of vel: " + velNormal);
         //print("Start: " + pointsArray[y][x]);
         ////pointsArray[y][x] = point.add(pVel.sub(velNormal.mult(1+.01))); // Adds normal velocity
         //println("   New: " + pointsArray[y][x]);
       
        //velArray[y][x] = new PVector(velArray[y][x].x*.2,0,velArray[y][x].z*.2);

        velArray[y][x] = new PVector(0,0,0);
      
      }
      //else
        pointsArray[y][x].add(velArray[y][x].mult(dt));
    }
  }  
}
void keyPressed(){
  if(key == ' ')
    paused = !true;
  if(key == 'j'){
    obstaclePos.add(new PVector(-20,0,0));
  }
  if(key == 'l'){
    obstaclePos.add(new PVector(20,0,0));
  }
  if(key == 'i'){
    obstaclePos.add(new PVector(0,-20,0));
  }
  if(key == 'k'){
    pointsArray[height-1][width-1].add(new PVector(0,20,0));
  }
    camera.HandleKeyPressed();

}

void keyReleased(){
  camera.HandleKeyReleased();
}

void draw(){
  background(255);
  //directionalLight(255, 255, 255, -2, 0, 0);
  //lights();
  if(!paused){
  camera.Update(1.0/frameRate);
  for(int i = 0; i < 100;i++){
    update(1.0/frameRate);
  }

  //Loop through each point and assign
  fill( 0, 0, 255 );
  textureMode(NORMAL);
  beginShape(QUADS);
  texture(img);
  for(int y = 0; y < height-1;y++){
    for(int x = 0; x < width-1;x++){
      //if(!connected[y][x])
      //  continue;

      PVector p1 = pointsArray[y][x];
      PVector p2 = pointsArray[y][x+1];
      PVector p3 = pointsArray[y+1][x+1];
      PVector p4 = pointsArray[y+1][x];

      float i = (float)y;
      float j = (float)x;

      vertex(p1.x,p1.y,p1.z,j/width,i/height); 

      vertex(p2.x,p2.y,p2.z,(j+1)/width,i/height);
      vertex(p3.x,p3.y,p3.z,(j+1)/width,(i+1)/height);
      vertex(p4.x,p4.y,p4.z,j/width,(i+1)/height);
       
    
      
    }
  }
  endShape();

  
  fill( 255, 0, 0 );
  pushMatrix();
    translate( obstaclePos.x, obstaclePos.y, obstaclePos.z );
    noStroke();
    sphere( obsRadius );
  popMatrix();

  }
}
