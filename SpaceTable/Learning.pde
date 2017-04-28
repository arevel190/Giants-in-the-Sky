class PopUp extends Body implements iTangible {
   
  public TuioObject tobj;
  boolean isFake;
  boolean isStar;
  boolean isPrompt;
  String typeOfObject;
  String imageType;
  PImage objectImage = star;
  float lifeOfObject;
  String massOfObject;
  String objDescription;
  float angle;
  float newAngle;
  
  PopUp(PVector pos, float diameter, float mass) {
    position = new PVector();
    velocity = new PVector();
    this.position = pos;
    this.diameter = diameter;
    this.mass = mass;
    allPopUps.add(this);   
  }
  
  PopUp (TuioObject tuioObj) {
    BodyInit();
    isFake = true;
    diameter = 0;
    mass = 0;
    tobj = tuioObj;
    UpdateFromTuio(tuioObj);
    allPopUps.add(this);
    tangibleMap.put(tuioObj.getSessionID(), this);
  }
  
  void UpdateFromTuio(TuioObject tuio) {
    position.x = tuio.getScreenX(width);
    position.y = tuio.getScreenY(height);
    angle = tuio.getAngle();
    newAngle = map(angle,0,6.2,0,359);
  }
  
  void Update() {
    this.draw();
    DisplayInfo();
  }
  
  void Die() {
    allPopUps.remove(this);
    super.Die();
  }
  
  void draw() {
    pushStyle();
    fill(255,100);
    ellipse(position.x, position.y, 10, 10);
    
    imageMode(CORNER);
    pushMatrix(); // Show telescope Prompt when not on top of object
    translate(position.x, position.y);
    rotate(radians(newAngle));
    if(isStar == false && isPrompt == false) {
      image(telescopePrompt,- 5 + tangibleX,tangibleY, 290, 190);
    }
    
    popMatrix();
    popStyle();
  }
  
  void DisplayInfo() { // Information displayed by the Telescope tangible
    for(Star aStar : allStars) {
        if(dist(position.x, position.y, aStar.position.x, aStar.position.y) <= (diameter + aStar.diameter) / 2) { // Information displayed by the Telescope tangible
          isStar = true;
          showInfo();
          if(aStar.type == StellarObject.RED_DWARF) {
            if(aStar.deletedFromList == false) {
              typeOfObject = "Low Mass Star or Red Dwarf";
              massOfObject = "0.5 Solar Masses";
              objDescription = "Red Dwarfs are relatively cool stars. They tend to live a long time.";
              objectImage = redDwarf;
              lifeOfObject = aStar.lifeDisplay;
            } else {
              typeOfObject = "White Dwarf";
              massOfObject = "0.05 to 1.4 Solar Masses";
              objDescription = "They are remnants of the core of a middle sized star. They are around the size of planet.";
              objectImage = star;
              lifeOfObject = aStar.lifeDisplay;
            } 
          } else if (aStar.type == StellarObject.YELLOW || aStar.type == null) {
            if(aStar.deletedFromList == false) {
              typeOfObject = "Medium Mass Star";
              massOfObject = "1 Solar Mass";
              objDescription = "Yellow stars are medium sized stars. They are very similar to the sun.";
              objectImage = star;
              lifeOfObject = aStar.lifeDisplay;
            } else {
              typeOfObject = "White Dwarf";
              massOfObject = "0.05 to 1.4 Solar Masses";
              objDescription = "They are remnants of the core of a middle sized star. They are around the size of a small planet.";
              objectImage = star;
              lifeOfObject = aStar.lifeDisplay;
            } 
          } else if (aStar.type == StellarObject.BLUE) {
            if(aStar.deletedFromList == false) {
              typeOfObject = "High Mass Star";
              massOfObject = "8 to 20 Solar Masses";
              objDescription = "Blue Stars are very big and bright stars. They only live for a short time.";
              objectImage = blueStar;
              lifeOfObject = aStar.lifeDisplay;
            } else {
              typeOfObject = "Neutron Star";
              massOfObject = "1.4 Solar Masses";
              objDescription = "A very small and super dense core of a giant dead star. They also spin very fast!";
              objectImage = blueStar;
              lifeOfObject = aStar.lifeDisplay;
            }
          }
        } else {
          isStar = false;
        }
      }
      
    for(BlackHole hole : allBlackHoles) {
       if(dist(position.x, position.y, hole.position.x, hole.position.y) <= (diameter + hole.diameter)/2){
         isStar = true;
         typeOfObject = "Black hole";
         massOfObject = "Unknown";
         objDescription = "Black holes are places where gravity is so strong that not even light can escape.";
         lifeOfObject = hole.lifeDisplay;
         showInfo();
       } else {
          isStar = false;
       }
     }
     
     for(Planet planet : allPlanets) {
      if(dist(position.x, position.y, planet.collider.x, planet.collider.y) <= (diameter + planet.diameter)/2) {
        isStar = true;
        typeOfObject = "Planet";
        massOfObject = "0.0009546 Solar Masses";
        objDescription = "Planets are celestial bodies that orbit around a star. Earth, where we live is one of them.";
        lifeOfObject = planet.lifeDisplay;
        showInfo();
      } else {
          isStar = false;
      }
    }
    
    for(Prompt prompt : allPrompts) {
      if(dist(position.x, position.y, prompt.position.x, prompt.position.y) <= 90) { // Proximity between prompt and telescope tangible
        isPrompt = true;       
        typeOfObject = prompt.interText;
        imageType = prompt.promptType;
        showInfo();
      } else {
        isPrompt = false;
      }
    }
    
  }
  
//  CONSTANT VARIABLES
  int yAddText = 47;
  int xAddText = 60;
  int adjustX = 145;
  
  int tangibleX = 100; // Adjust these values to accomodate the telescope tangible
  int tangibleY = -100;
  
  int promptTanX = -175; // Use this to Adjust prompt pop-up
  int promptTanY = 90;
//  

  void showInfo() {
      pushMatrix();
      pushStyle();
//      imageMode(CENTER);
//      textAlign(CENTER);
      fill(0);
      stroke(255);
      strokeWeight(2);
      
      translate(position.x, position.y);
      rotate(radians(newAngle));
      
      if(isStar && isPrompt == false) {
//        rect(position.x - 5, position.y, 290, 140); // Pop-up Frame is this one.
        pushStyle();
        imageMode(CORNER);
        image(popupFrame,- 5 + tangibleX,tangibleY, 290, 190);
        fill(255);
        textSize(18);
        textAlign(CENTER);
        text("" + typeOfObject, adjustX + tangibleX, 20 + tangibleY);
        textSize(14.5);
        textAlign(LEFT);
        text("Age: " + int(lifeOfObject) + " Million Years", xAddText + tangibleX, yAddText + tangibleY);
        text("Mass: " + massOfObject, xAddText + tangibleX, (yAddText*2) + tangibleY);
        text("" + objDescription, xAddText + tangibleX, (yAddText*2.5) + tangibleY, 222, 100);
        popStyle();
      } 
      
      popStyle();
      popMatrix();
      
      if(isPrompt && isStar == false) { // Render of the Prompt        
        pushStyle();
        imageMode(CORNER);
        pushMatrix();
        translate(position.x, position.y);
        rotate(radians(newAngle));
        
        if(imageType == "Neutron Star") {
          image(neutronStarPromptExp,- 5 + tangibleX,tangibleY, 290, 190);
        } else if(imageType == "Black Hole") {
          image(holePromptExp,- 5 + tangibleX,tangibleY, 290, 190);
        } else if(imageType == "Planetary Nebula") {
          image(supernovaPromptExp,- 5 + tangibleX,tangibleY, 290, 190);
        } else if(imageType == "White Dwarf") {
          image(whiteStarPromptExp,- 5 + tangibleX,tangibleY, 290, 190);
        } else if(imageType == "Shred Star") {
          image(shredStarPromptExp,- 5 + tangibleX,tangibleY, 290, 190);
        }
        
        popMatrix();                
        popStyle();
        
      }
      
  }
  
}

//not technically a class because don't need it.

boolean open = false;
int panelWidth = 300;
int panelSpeed = 30;
int fromRight = 1920; //why doesn't just saying "width" work??
int imageWidth = 75;
String[] bodyText = new String[8];
PImage[] popImages = new PImage[8];


void populateBodyText() {
  bodyText[0] = "Black Hole: Black holes are places where gravity is so strong that not even light can escape!";
  bodyText[1] ="Red Giant: Red Giants are big old stars. The red color means they are not as hot as Blue or Yellow stars.";
  bodyText[2] ="Blue Star: Are very big and bright stars. They only live for a short time.";
  bodyText[3] ="Planet: These are celestial bodies that orbit around a star. Earth, where we live is one of them.";
  bodyText[4] ="Planetary Nebula: This is the result of the star blowing off its outer layers as it ran out of fuel.";
  bodyText[5] ="Asteroid: These are small rocky bodies that wander the universe.";
  bodyText[6] ="Neutron Star: A very small and super dense core of a dead giant star. They can have twice the mass of the sun!";
  bodyText[7] ="White Dwarf: They are remnants of the core of a middle sized star. Are around tge size of planet earth with as much mass as the sun.";
}

void populateImages() {
  popImages[0] = blackHole;
  popImages[1] = redGiant;
  popImages[2] = blueStar;
  popImages[3] = planet;
  popImages[4] = planetaryNebulaeTwo;
  popImages[5] = rock;
  popImages[6] = neutronStar;
  popImages[7] = whiteDwarf;
}

void learningPanel () {
  //populateBodyText();
  //populateImages();
  //openClose();
  //drawPanel();
  //for (int i = 0; i <= 7; i = i+1) {
  //  eachBody(i, popImages[i], bodyText[i]);
  //}
}

void drawPanel() {
  //pushStyle();
  //fill(0);
  //strokeWeight(1);
  //stroke(255);
  //rect(fromRight, 0, panelWidth, height);
  //popStyle();
}

void openClose() {
  //if (open == false) {
  //  if (fromRight < width) {
  //    fromRight += panelSpeed;
  //  }
  //} else {
  //  if (fromRight > width-panelWidth){
  //    fromRight -= panelSpeed;
  //  }
  //}
}

void eachBody(int fromTop, PImage image, String text) {
  //fromTop *= 120;
  //imageMode(CORNER);
  //image(image, fromRight + 10, fromTop + 20, imageWidth, imageWidth);
  //imageMode(CENTER);
  //fill(0);
  //textAlign(LEFT);
  //pushStyle();
  //fill(255);
  //text(text, fromRight + imageWidth + 20, fromTop + 30, panelWidth - imageWidth - 40, 100);
  //popStyle();
}