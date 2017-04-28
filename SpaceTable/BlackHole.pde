boolean holeLimit = false;
int holeTextLife = 0;

class BlackHole extends Body implements iTangible {
  
  public TuioObject tobj;
  boolean init = false;
  PImage image;
  float lifeDisplay = 0;
  float evaporation = 0;
  
  BlackHole(PVector pos, float diameter, float mass) {
    addBlackHoles.remove(this);
    position = new PVector();
    velocity = new PVector();
    this.position = pos;
    this.diameter = diameter;
    this.mass = mass;
    allBlackHoles.add(this);   
  }
  
  BlackHole (TuioObject tuioObj) { // ADD THE LIMITATION OF STARS HERE!!!!!!!!!!!!!!!!!!!!!!!!
    BodyInit();
    diameter = 100;
    mass = 7500;
    image = blackHole;
    tobj = tuioObj;
    UpdateFromTuio(tuioObj);
    allBlackHoles.add(this);
    tangibleMap.put(tuioObj.getSessionID(), this);
//    CreateFromTuio(tuioObj);
  }
  
  void UpdateFromTuio(TuioObject tuio) {
    position.x = tuio.getScreenX(width);
    position.y = tuio.getScreenY(height);
  }
  
  void Update() {
    this.draw();
    Collide();
    removeHole();
    timeRegister();
    evaporate();
  }
  
  void Die() {
    allBlackHoles.remove(this);
    super.Die();
  }
  
  void draw() {
    imageMode(CENTER);
    image(blackHole, position.x, position.y, diameter, diameter);
  }
  
  //void Collide() {
  //  for(BlackHole hole : allBlackHoles) {
  //     if(dist(position.x, position.y, hole.position.x, hole.position.y) <= (diameter + hole.diameter)/2) {
  //       if (hole == this) continue;
  //       hole.diameter = 0;
  //       diameter += 30;
  //     }
  //   }
  //}
  
  void Collide() {
        
    for (BlackHole other : allBlackHoles) {
      if (other == this) continue;
      //check for collision
      if(dist(other.position.x, other.position.y, this.position.x, this.position.y) < (other.diameter/2 + this.diameter/2)) {
            //float overlap = ( other.diameter/2 + this.diameter/2) - dist(other.position.x, other.position.y, this.position.x, this.position.y); 
            BlackHole larger = this;
            BlackHole smaller = other;
      if (diameter < other.diameter) {
          smaller = this;
          larger = other;
        }  
        
        float areaSwapped = PI * smaller.diameter * smaller.diameter - PI * (smaller.diameter - 1) * (smaller.diameter - 1); // area of outermost pixel ring;
//        smaller.diameter --;
        smaller.diameter -= 10;    
        float larger_area = PI * larger.diameter * larger.diameter;
        larger_area += areaSwapped;
        larger.diameter = sqrt(larger_area/PI);                         
      }
      
      
      float dx = other.position.x - this.position.x;
      float dy = other.position.y - this.position.y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = other.diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = position.x + cos(angle) * minDist;
        float targetY = position.y + sin(angle) * minDist;
        float ax = (targetX - other.position.x) * spring;
        float ay = (targetY - other.position.y) * spring;
        velocity.x -= ax;
        velocity.y -= ay;
        other.velocity.x += ax;
        other.velocity.y += ay;
      }
      
    }  
  }
  
  void removeHole() {
    if(diameter <= 5) {
      Destroy();  
    }
  }
  
  void evaporate() { // Evaporate after creation / White Dwarf / Neutron star
    evaporation++;
    if(evaporation >= 10000 && allStars.size() <= 0 || evaporation >= 18000) { // 10000
      this.Destroy();
    }
  }
  
  void timeRegister() {
    if(timePassing == true) {
        lifeDisplay += 1;
      }
  }
  
}

  void createBlackHole(float positionX, float positionY) {
    allBlackHoles.add( new BlackHole(new PVector(positionX, positionY), 100, 8000));
  }
  
  void collapseStar(float posX, float posY) {
    starXpos = posX;
    starYpos = posY;
    starCollapse = true;
  }