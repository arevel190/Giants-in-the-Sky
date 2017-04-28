class SpaceParticle extends Body {
  
  float lifeSpan = 0;
  color particleColor;
  
  SpaceParticle(PVector pos, float diameter, float mass, color partColor){
    position = new PVector();
    velocity = new PVector();
    this.position = pos;
    this.diameter = diameter;
    this.mass = mass;
    particleColor = partColor;
    particles.add(this);
  }
  
  void Update() {
    this.draw();
    applyGravity();
    move();
    removeOffScreen();
    collide();
    destroyParticle();
  }
  
  void Die() {
    particles.remove(this);
    addParticles.remove(this);
    super.Die();
  }
  
  void draw(){
    pushStyle();
    ellipseMode(CENTER);
    fill(particleColor);
    ellipse(position.x, position.y, diameter, diameter);
    popStyle();
  }
  
  void applyGravity() {
    for(BlackHole hole : allBlackHoles) {
      PVector gravity = hole.gravityAt(position);
      velocity.add(gravity);
    }
    
    for(Star star : allStars) {
      if(star.image == neutronStar) {
        PVector gravity = star.gravityAt(position);
        velocity.add(gravity);
      }
    }
  }
  
  void move() {
    position.add(velocity);
  }
  
  void removeOffScreen() {
    if(position.x < -300 || position.y > width + 300 || position.y < -300 || position.y > height + 300){
      cometsOnScreen --;
      Destroy();
    }
  }
  
  void collide() {
    for(BlackHole hole : allBlackHoles) {
       if(dist(position.x, position.y, hole.position.x, hole.position.y) <= (diameter + hole.diameter)/2){
         Destroy();
       }
     }
     
     for(Star star : allStars) {
       if(dist(position.x, position.y, star.position.x, star.position.y) <= (diameter + star.diameter)/2 && star.image == neutronStar){
         star.matter +=1;
         Destroy();
       }
     }
  }
  
  
  void destroyParticle() {
    lifeSpan += 0.25;
    
    if(lifeSpan >= 6) {
      Destroy();
    }    
  }
  
}