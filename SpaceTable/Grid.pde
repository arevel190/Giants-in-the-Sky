//grid stuff
int gap = 50;
int dotSize = 1;
int roundedx;
int roundedy;
int gridSpring = 25; // Lower number = stronger gravity

void initializeGrid () {
  gridSize(gap);

  for (int i = 0; i < roundedx+1; i++) {
    for (int j = 0; j < roundedy+1; j++) {
      grid.add(new Grid(gap*i, gap*j, dotSize, gridSpring));
      grid.add(new Grid(gap*i + (gap/4), gap * j, dotSize, gridSpring));
      grid.add(new Grid(gap*i, gap * j + (gap/4), dotSize, gridSpring));
      grid.add(new Grid(gap*i + (gap/2), gap * j, dotSize, gridSpring));
      grid.add(new Grid(gap*i, gap * j + (gap/2), dotSize, gridSpring));
      grid.add(new Grid(gap*i + (gap/4*3), gap * j, dotSize, gridSpring));
      grid.add(new Grid(gap*i, gap * j + (gap/4*3), dotSize, gridSpring));
    }
  }
}

void drawGrid () {
  for (Grid gridItem : grid) {
    gridItem.applyGravity();
    gridItem.keepShape();
    gridItem.display();
  }
}

void gridSize(int e) {
  float xCount = width/e;
  roundedx = Math.round(xCount);
  float yCount = height/e;
  roundedy = Math.round(yCount);
}

class Grid {
  
  int diameter;
  PVector gravInfluence;
  PVector springBack;
  int spring;
 
  Grid(float xin, float yin, int din, int springIn) {
    diameter = din;
    gravInfluence = new PVector(xin, yin);
    springBack = new PVector(xin, yin);
    spring = springIn;
  }
  
 
  void applyGravity() {
    
    for(Star star : allStars){
      PVector gravity = star.gridGrav(gravInfluence);
      gravInfluence.add(gravity);
      //make grid regenerate
      if(dist(gravInfluence.x, gravInfluence.y, star.position.x, star.position.y) <= (diameter + star.diameter)/2){
        gravInfluence.x = springBack.x;
        gravInfluence.y = springBack.y;
      } 
    }
    
    for(BlackHole hole : allBlackHoles) {
      PVector gravity = hole.gridGrav(gravInfluence);
      gravInfluence.add(gravity);
      //make grid regenerate
      if(dist(gravInfluence.x, gravInfluence.y, hole.position.x, hole.position.y) <= (diameter + hole.diameter)/2){
        gravInfluence.x = springBack.x;
        gravInfluence.y = springBack.y;
      } 
    }
        
  }
  
  void keepShape () {
    PVector direction = new PVector(springBack.x - gravInfluence.x, springBack.y - gravInfluence.y);
    direction.normalize();
    float d = dist(gravInfluence.x, gravInfluence.y, springBack.x, springBack.y);
    direction.mult(d/spring);
    gravInfluence.add(direction);
  }
  
  void display() {
    fill(255);
    ellipse(gravInfluence.x, gravInfluence.y, diameter, diameter);
  }
  
}