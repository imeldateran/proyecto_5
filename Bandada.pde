class Bandada {
  ArrayList<Boid> boids; 

  Bandada() {
    boids = new ArrayList<Boid>(); 
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}