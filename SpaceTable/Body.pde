abstract class Body {
  
  PVector position;
  PVector velocity;
  float diameter;
  float mass;
  
  abstract void Update();
  
  void Die() {
    allBodies.remove(this);
  }
  
  void BodyInit() {
    allBodies.add(this);
    position = new PVector();
    velocity = new PVector();
  }
  
  void Destroy() {
    toDestroy.add(this);
  }
  
  void addToList() {
    allBodies.add(this);
  }
    
  void applyForce(PVector force){
    
  }
  

  PVector gravityAt(PVector otherPos) {
    PVector direction = new PVector(position.x - otherPos.x, position.y - otherPos.y);
    direction.normalize();
    float d = dist(otherPos.x, otherPos.y, position.x, position.y);
    direction.mult(mass*2/(d*d));
    return direction;
  }
  
  PVector gridGrav(PVector otherPos) {
    PVector direction = new PVector(position.x - otherPos.x, position.y - otherPos.y);
    direction.normalize();
    float d = dist(otherPos.x, otherPos.y, position.x, position.y);
    direction.mult((mass*2)/(d*d)); //double mass to exaggerate effect on grid
    return direction;
  }
  
//  void pullOut() {
//    pushStyle();
//    fill(255);
//    stroke(255);
//    strokeWeight(1);
//    line(position.x, position.y, position.x+50, position.y-50);
//    line(position.x+50, position.y-50, position.x+150, position.y-50);
//    rect(position.x+70, position.y-150, 160, 100);
//    fill(0);
//    stroke(0);
//    text(increment, position.x + 90, position.y - 120); 
//    popStyle();
//  }
  
//  void callPullout() {
//    increment ++;
//    if (increment < 100) {
//      pullOut();
//    }
//  }
  
//  void callPullout() {
//     boolean first = true;
//     int increment = 0;
//     
//     int 
//  }
  
//this method does crazy things...  
//  PVector gridReturn(PVector otherPos) {
//    PVector direction = new PVector(position.x - otherPos.x, position.y - otherPos.y);
//    direction.normalize();
//    float d = dist(otherPos.x, otherPos.y, position.x, position.y);
//    direction.div(mass/(d*d));
//    return direction;
//  }
  
  abstract void draw();
}