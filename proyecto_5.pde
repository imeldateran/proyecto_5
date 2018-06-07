
import processing.sound.*;
SoundFile file;
Bandada bandada;

PShape s;

PImage arbol;
int y;


void setup() {

  size(800,800);
  
  arbol=loadImage ("arbold.jpg");
 image(arbol, 0, 0);
 filter(GRAY);
 
  file = new SoundFile(this, "aves_mixdown.aif");
  file.play();
   s = loadShape("47399.svg");
  bandada= new Bandada();
  for (int i = 0; i < 180; i++) {
   bandada.addBoid(new Boid(20,30));
  }
}

void draw() {
  background(arbol);
  
   shape(s, 20, 20, 28, 28);
  bandada.run();
}
class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    
  float maxspeed;   

    Boid(float x, float y) {
    acceleration = new PVector(0, 0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    position = new PVector(320, 30);
    r = 20.0;
    maxspeed = 1;
    maxforce = 0.04;
  }

  void run(ArrayList<Boid> boids) {
    bandada(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }
    void bandada(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   
    PVector ali = align(boids);      
    PVector coh = cohesion(boids);   
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  
    return steer;
  }

  void render() {
    float theta = velocity.heading2D() + radians(80);
    pushMatrix();
    translate(position.x, position.y);
    
 rotate(theta);
    shape(s, 15, 15, 33, 33);
    popMatrix();
  }

  void borders() {
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    
  }
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
       PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        
        steer.add(diff);
        count++;            
      }
    }
    
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 150;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); 
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  
    } 
    else {
      return new PVector(0, 0);
    }
  }
}