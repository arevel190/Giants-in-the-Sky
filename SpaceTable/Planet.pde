class Planet extends Body {
  
  float planetRotationX = 0.2;
  float planetRotationY = 0.2;
  float r1 = int(random(150, 250));
  float r2 = int(random(250, 320));
  float theta = 0;
  public PVector collider;
  float lifeDisplay = 0;
  boolean inOrbit = true;
  int orbitInt = 0;
  
  Planet(PVector pos, float diameter, float mass, PVector col) {
    addPlanets.remove(this);
    position = new PVector();
    velocity = new PVector();
    position = pos;
    collider = col;
    this.diameter = diameter;
    this.mass = mass;
    allPlanets.add(this);
  }
  
  void Update() {
    this.draw();
    collide();
    timeRegister();
    stillInOrbit();
    applyGravity();
    move(); 
  }
  
  void Die() {
    allPlanets.remove(this);
    super.Die();
  }
  
  void draw() {
    
    float x = r1 * cos(theta);
    float y = r2 * sin(theta); // Change to r2 for elliptical orbit
    
    float originalPosX = position.x; 
    float originalPosY = position.y;
    
    float newPosX = originalPosX + x;
    float newPosY = originalPosY + y;
    
    float distToStar = (dist(originalPosX, originalPosY, newPosX, newPosY) / 10000);
    
    if(inOrbit == true) {
      collider.x = newPosX;
      collider.y = newPosY;
    } else {
      position.x = collider.x;
      position.y = collider.y;
    }
       
    ellipseMode(CENTER);
    fill(255,0,0);
    image(planet, collider.x, collider.y, diameter, diameter);
    
    if(inOrbit == true) {
      theta += (0.05 - (distToStar * 1.5));
    }
    
  }
  
  void collide() {     
    for(Star star : allStars) {
      if(dist(collider.x, collider.y, star.position.x, star.position.y) <= (diameter + star.diameter)/2){
        Destroy();
      }
    }
    
    for(BlackHole hole : allBlackHoles) {
       if(dist(collider.x, collider.y, hole.position.x, hole.position.y) <= (diameter + hole.diameter)/2){
         Destroy();
       }
    }
    
    for(Planet planet : allPlanets) {
      if(dist(collider.x, collider.y, planet.collider.x, planet.collider.y) <= (diameter + planet.diameter)/2){
        if (planet == this) continue;
        Destroy();
      }
    }
  }
  
  void stillInOrbit() {
    orbitInt = 0;
    
    if(inOrbit == true) {
      for(Star star : allStars) {
        if(dist(position.x, position.y, star.position.x, star.position.y) <= 5) {
          orbitInt += 1;
        }
      }    
      
      if(orbitInt <= 0) {
        inOrbit = false;
        velocity.x = 0;
        velocity.y = 0;
      }
    }
  }
  
  void move() {
    if(inOrbit == false) {
      collider.add(velocity);  
    }
  }
  
  void applyGravity() {
    if(inOrbit == false) {
      for(Star star : allStars) {
        PVector gravity = star.gravityAt(position);
        velocity.add(gravity);
      }
      
      for(BlackHole hole : allBlackHoles){
        PVector gravity = hole.gravityAt(position);
        velocity.add(gravity);
      }
    }
  }
    
  void timeRegister() {
    if(timePassing == true) {
        lifeDisplay += 1;
      }
  }
  
}