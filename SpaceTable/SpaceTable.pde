PImage planet;
PImage star;
PImage redGiant;
PImage orangeGiant;
PImage redDwarf;
PImage blueStar;
PImage nebulaBlue;
PImage nebulaPurple;
PImage nebulaYellow;
PImage nova;
PImage neutronStar;
PImage whiteDwarf;
PImage planetaryNebulaeOne;
PImage planetaryNebulaeTwo;
PImage planetaryNebulaeThree;
PImage planetaryNebulaeFour;
PImage popupFrame;
PImage telescopePrompt;
PImage supernovaPrompt;
PImage neutronStarPrompt;
PImage whiteStarPrompt;
PImage holePrompt;
PImage shredStarPrompt;
PImage supernovaPromptSucc;
PImage neutronStarPromptSucc;
PImage whiteStarPromptSucc;
PImage holePromptSucc;
PImage shredStarPromptSucc;
PImage supernovaPromptExp;
PImage neutronStarPromptExp;
PImage whiteStarPromptExp;
PImage holePromptExp;
PImage shredStarPromptExp;


PImage blackHole;
PImage rock;
short mass;
byte h;
PFont font;
boolean release = false;
boolean isOver = false;

// Blackhole Spawn
boolean starCollapse = false; // Active when star just collapsed
float starXpos; // X Position of collapsing star
float starYpos; // Y Position of collapsing star


// Global Time
boolean timePassing = true;

Star sun; // Creation of the star object. INITIALIZING THE STAR OBJECT CALLED SUN
Star secondSun;
Planet earth;
Prompt testPrompt;

float spring = 0.01;

ArrayList<Body> toDestroy = new ArrayList();
ArrayList<Comet> allComets = new ArrayList();
ArrayList<Planet> allPlanets = new ArrayList();
ArrayList<Planet> addPlanets = new ArrayList();
ArrayList<Star> allStars = new ArrayList();
ArrayList<BlackHole> allBlackHoles = new ArrayList();
ArrayList<BlackHole> addBlackHoles = new ArrayList();
ArrayList<BlackHole> toDestroyBlackHoles = new ArrayList();
ArrayList<SpaceParticle> particles = new ArrayList();
ArrayList<SpaceParticle> addParticles = new ArrayList();
ArrayList<Body> allBodies = new ArrayList();
ArrayList<Grid> grid = new ArrayList();
ArrayList<Cursor> cursors = new ArrayList();
ArrayList<Pullout> allPullout = new ArrayList();
ArrayList<PopUp> allPopUps = new ArrayList();
ArrayList<Prompt> allPrompts = new ArrayList();
ArrayList<Prompt> addPrompts = new ArrayList();

Cursor mouseCursor;

void setup() {
  size(displayWidth, displayHeight);
  SetupStarMap();
  SetupCursorMap();
  SetupIdToType();
  tuioClient  = new TuioProcessing(this);

  frameRate(60);
  planet = loadImage("planet.png");
  star = loadImage("star.png");
  redGiant = loadImage("redGiant.png");
  orangeGiant = loadImage("orangeGiant.png");
  blueStar = loadImage("blueStar.png");
  redDwarf = loadImage("redDwarf.png");
  nebulaBlue = loadImage("nebulaBlue.png");
  nebulaYellow = loadImage("nebulaYellow.png");
  nebulaPurple = loadImage("nebulaPurple.png");
  nova = loadImage("Supernova.png");
  blackHole = loadImage("blackHole.png");
  neutronStar = loadImage("neutronStar.png");
  whiteDwarf = loadImage("whiteDwarf.png");
  planetaryNebulaeOne = loadImage("planetaryNebulaeOne.png");
  planetaryNebulaeTwo = loadImage("planetaryNebulaeTwo.png");
  planetaryNebulaeThree = loadImage("planetaryNebulaeThree.png");
  planetaryNebulaeFour = loadImage("planetaryNebulaeFour.png");
  popupFrame = loadImage("popupFrame.png");
  telescopePrompt = loadImage("teleMessage.png");
  supernovaPrompt = loadImage("supernovaPrompt.png");
  neutronStarPrompt = loadImage("neutronPrompt.png");
  whiteStarPrompt = loadImage("whiteStarPrompt.png");
  holePrompt = loadImage("holePrompt.png");
  shredStarPrompt = loadImage("shredPrompt.png");
  
  supernovaPromptSucc = loadImage("supernovaPromptSucc.png");
  neutronStarPromptSucc = loadImage("neutronStarPromptSucc.png");
  whiteStarPromptSucc = loadImage("whiteStarPromptSucc.png");
  holePromptSucc = loadImage("holePromptSucc.png");
  shredStarPromptSucc = loadImage("shredStarPromptSucc.png");
  
  supernovaPromptExp = loadImage("supernovaPromptExp.png");
  neutronStarPromptExp = loadImage("neutronPromptExp.png");
  whiteStarPromptExp = loadImage("whiteStarPromptExp.png");
  holePromptExp = loadImage("holePromptExp.png");
  shredStarPromptExp = loadImage("shredPromptExp.png");
  
  allComets = new ArrayList();
  allBodies = new ArrayList();
  allBlackHoles = new ArrayList();
  allPlanets = new ArrayList();
  allPopUps = new ArrayList();
//  sun = new Star(new PVector(width/2 , height/2), star.width-15, 15000, star); // Uncomment this to create a star at start
  
//  allBlackHoles.add( new BlackHole(new PVector(100,100), 100, 10000));
//  createBlackHole(width/2, height/2);
//  earth = new Planet(new PVector(width/2 , height/2), 50, 500, new PVector(0,0));
  rock = loadImage("rock.png");
  h = 80;
  font = createFont("Onyx", 12);
  
  initializeGrid();
  
}


void draw() { 
  
  TuioUpdate();
  background(0);
  
//  image(star, width/2, height/2, 700,700);
  
  float ds = dist(mouseX, mouseY, width/2, height/2 - 60);
  drawGrid ();
  stroke(200*(ds/250), 100, 50);
  strokeWeight(4);
  //line(width/2, height/2 - h, mouseX, mouseY);
  fill(150);
  noStroke();
//  println(allStars.size() - afterStar);
//  println("afterStar " + afterStar);
//  println("allStars " + allStars.size());
//  println("# of Blackholes: " + allBlackHoles.size());
//  println("Prompt State: " + promptState);
  numberOfStars = allStars.size() - afterStar; // Keeps track of the current number of living stars in the system
    
//  rect(tuioX,tuioY,100,100);
 for(Cursor cur : cursors) {
    cur.Update();
  }
  
  for(Body bod : allBodies) {
    bod.Update(); // Updating all of the tuio objects on the sketch
  }
  
  for(Body gone : toDestroy) {
    gone.Die(); // Destroys the objects that are set to destroy (Comets that go away from the sketch for instance)
  }
   
  for(SpaceParticle add : addParticles) {
    add.addToList(); // Adds new particles to the ArrayList
  }
   
  for(BlackHole add : addBlackHoles) {
    add.addToList(); // Adds new Black Holes to the ArrayList
  }
  
  for(Planet add : addPlanets) {
    add.addToList(); // Adds new Planets to the ArrayList
  }
  
  for(Prompt add : addPrompts) {
    add.addToList(); // Adds new Prompts to the ArrayList
  }
  
  for(int i = 0; i < addBlackHoles.size(); i++) { // Avoids creating copies of Black holes
    addBlackHoles.remove(i);
  }
  
  for(int i = 0; i < addPlanets.size(); i++) { // Avoids creating copies of Planets
    addPlanets.remove(i);
  }
  
  for(int i = 0; i < addPrompts.size(); i++) { // Avoids creating copies of Prompts
    addPrompts.remove(i);
  }
              
  if(starCollapse) { // Creation of Black Holes
    createBlackHole(starXpos, starYpos);
    starCollapse = false;
  }
  
  learningPanel();
  StarLimitMessage();
  HoleLimitMessage();
  DisplayPrompt();
}

void mousePressed() {
  mouseCursor = new Cursor();
  release = true;
}

void mouseReleased() {
  mouseCursor.OnRemove();
  release = false;
}

void keyPressed() {
  
  if (key == 'c') {
    for(Body bod : allBodies){
     bod.Destroy(); 
     afterStar = 0;
     neutronPrompt = false;
     nebulaePrompt = false;
     blackholePrompt = false;
     whiteDwarfPrompt = false;
     shredPrompt = false;
     promptState = 0;
     promptReset = 0;
    }
  } else if (key == 'l') {
    if (open == false){
      open = true;
    } else {
      open = false;
    }
  } else if (key == '1') {
    timePassing = true;  
  } else if(key == '2') {
    timePassing = false; 
  }
   
}