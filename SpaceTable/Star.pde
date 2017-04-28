// Star Limitations
int numberOfStars = 0; // Number of stars in the system
int textLife = 0; // Warning sign life
boolean starLimit = false; // Once true the warning sign is activated
int afterStar = 0; // Number of stars that are dead

int sizeOfCore = 30; // Controls the size of White dwarf and Neutron Star
int starDiameter = 150;
int shredDistance = 80;

class Star extends Body implements iTangible {

  public TuioObject tobj;
  boolean isFake; //used for debugging without reactivision
  PImage image;
  PImage nebula;
  float lifeOfStar;
  float lifeDisplay; // Life of star to display
  float completeLifeOfStar;
  float stageOfStar;
  int explosionX;
  int explosionY;
  int nebulaDuration;
  float neutronRotate;
  StellarObject type;
  int massDifference;
  int xDifference;
  PImage graphic;
  float pulsarOrHole;
  float neutronOrPulsar;    
  int nebulaeColor; // USE THIS TO CHANGE THE COLOR OF THE SPACE NEBULAE
  color partColor; // Color of star particles
  boolean beingShredded = false;
  float growingRate; // Grow Rate of Star
  boolean deletedFromList = false; // Prevents from subtracting more stars to the limit
  float evaporation = 0; // Rate of evaporation once created (Applies to Neutron, white dwarf and black hole)
  int matter = 0; // Matter Necessary to turn into a black hole when the star is a Neutron star.
  boolean recentCreation = true; // Checks if the star (neutron / white) has recently been created.
    
  // Pullout for each type of star
  Pullout redGiantText;
  Pullout orangeGiantText;
  Pullout whiteDwarfText;
  Pullout neutronStarText;
  Pullout blackHoleText;
  Pullout blueStarText;
  Pullout standardStarText;

  Star(TuioObject tuioObj) {

    BodyInit();
    diameter = star.width-15;
    mass = 4000;
    lifeOfStar = 50;
    explosionX = 0;
    explosionY = 0;
    neutronRotate = 1;
    nebulaDuration = 500;
    pulsarOrHole = 0;
    image = star;
    nebula = nebulaBlue;
    tobj = tuioObj;
    UpdateFromTuio(tuioObj);
    allStars.add(this);
    tangibleMap.put(tuioObj.getSessionID(), this);
    CreateFromTuio(tuioObj);
//    numberOfStars += 1; // Adds one star to the limit number

    // Add text for stars
    redGiantText = new Pullout(position.x, position.y, "You created a \nred giant! \nit's huge!");
    orangeGiantText = new Pullout(position.x, position.y, "The star has \nturned orange! \nit's huge!");
    whiteDwarfText = new Pullout(position.x, position.y, "You created a \nwhite dwarf! \nit's tiny!");
    neutronStarText = new Pullout(position.x, position.y, "You created a \nneutron star!");
    blackHoleText = new Pullout(position.x, position.y, "The star has \ncollapsed into black hole!");
    blueStarText = new Pullout(position.x, position.y, "You created a \ngiant blue star!");
    standardStarText = new Pullout(position.x, position.y, "You created a \n star! wow!");
  } 


  Star(PVector pos, int diameter, int mass, PImage image) {
    BodyInit();
    isFake = true;
    this.position = pos;
    this.diameter = diameter;
    this.mass = mass;
    this.image = image;
    allStars.add(this);
    lifeOfStar = 2450;
    growingRate = 0.09;

    // Add text for stars (same as other constructor
    redGiantText = new Pullout(position.x, position.y, "You created a \nred giant! \nit's huge!");
    orangeGiantText = new Pullout(position.x, position.y, "You created an \norange giant! \nit's huge!");
    whiteDwarfText = new Pullout(position.x, position.y, "You created a \nwhite dwarf! \nit's tiny!");
    neutronStarText = new Pullout(position.x, position.y, "You created a \nneutron star!");
    blackHoleText = new Pullout(position.x, position.y, "You created an \nblack hole!");
    blueStarText = new Pullout(position.x, position.y, "You created a \nblue star!");
    standardStarText = new Pullout(position.x, position.y, "You created a \nyellow star!");
  }
    
  void Update() {
    starShreding();
    addPlanet();
    collapseNeutron();
    
    if (isFake) {
//      checkHover();
    } else {
      UpdateFromTuio(tobj);
    }

    draw();
  }

  void Die() {
    allStars.remove(this);
    super.Die(); 
  }
  
  
  void draw() { // Add here all the details that go with the star

    standardStarText.update(position.x, position.y);    

    if (lifeOfStar >= 0.4) { // Normal star after being stamped
 
      if (diameter <= 10) { // Destroy Star if shredded
        this.Destroy();
//        numberOfStars -= 1;
      }
      
      if(timePassing == true && beingShredded == false  || lifeOfStar <= 40) {
        lifeOfStar -= 1; // Passing of time
        lifeDisplay += 1;
        completeLifeOfStar += growingRate; // Grow in mass while getting older
      }

      diameter = starDiameter + completeLifeOfStar + massDifference; // Controls the diameter of the star PLAY WITH VALUE TO ADJUST!

      pushMatrix(); 
      imageMode(CENTER);
      image(image, position.x, position.y, diameter, diameter); // Displays the image of the star
      popMatrix();

      if (type == StellarObject.YELLOW) { // Adjust size of the star depending on mass
        massDifference = 0;
      } else if (type == StellarObject.RED_DWARF) {
        massDifference = -80;
      } else if (type == StellarObject.BLUE) {
        massDifference = 50;
      }
      
      if (type != StellarObject.RED_DWARF && lifeOfStar <= (stageOfStar*0.3) && lifeOfStar >= (stageOfStar*0.2)) { // Change color depending on life stage
        image = orangeGiant;
        orangeGiantText.update(position.x, position.y);
        partColor = color(255, 151, 25);
      } else if (type != StellarObject.RED_DWARF && lifeOfStar <= (stageOfStar*0.1)) {
        image = redGiant;  
        redGiantText.update(position.x, position.y); 
        partColor = color(255, 45, 45);
      }

      if(lifeOfStar <= 40 && lifeOfStar >= 26) { // Activate to go supernova!
        if(type == StellarObject.BLUE) {
          fill(255);
          for (int i = 0; i < 7; i++) {
            ellipse(position.x + random(-110,110), position.y + random(-110,110), 20,20);
          }
        }
      } else if(lifeOfStar <= 26 && lifeOfStar >= 24) {
        if(type == StellarObject.BLUE) {
          pushStyle();
          rectMode(CENTER);
          fill(255);
          rect(width/2, height/2,displayWidth, displayHeight);
          popStyle();
        }
      } else if(lifeOfStar <= 24 && lifeOfStar >= 0.5) { // SUGESTION: Change the transparency over time. To create a fade effect.
        if(type == StellarObject.BLUE) {
          goSupernova();
        }
      } else if (lifeOfStar <= 0.5) {
        completeLifeOfStar -= 20;
        growingRate = 0;
        beingShredded = false;
      }
            
    } else if (lifeOfStar == 0) { //////////////////////// DEATH OF THE STAR!!!  ////////////////// DEATH OF THE STAR!!!   ////////////////// DEATH OF THE STAR!!!  ////////////////// DEATH OF THE STAR!!!
            
      completeLifeOfStar = 0;
      
      if (beingShredded) {
        growingRate += 1; // Shrick object bc of Black Hole
      }
      
      evaporate(); // Initiates Evaporation of the star
      
      if (diameter <= 10) { // Destroy when consumed by black hole
        afterStar -= 1;
        this.Destroy();
      }
      
      if (type == StellarObject.YELLOW || type == StellarObject.RED_DWARF) { // Planetary Nebulae
        
        adjustStarLimit();
        
        if(whiteDwarfPrompt == true && promptState == 2 && recentCreation) { // Advance Prompt
            promptState += 1;
            promptWait = promptWaitTime;
        }
        
        image = whiteDwarf;
        partColor = color(246, 244, 255);  
        whiteDwarfText.update(position.x, position.y);

        if (nebulaeColor == 1) {
          nebula = planetaryNebulaeOne;
          xDifference = 0;
        } else if (nebulaeColor == 2) {
          nebula = planetaryNebulaeTwo;
          xDifference = 0;
        } else if (nebulaeColor == 3) {
          nebula = planetaryNebulaeThree;
          xDifference = 0;
        } else {
          nebula = planetaryNebulaeFour;
          xDifference = 4;
        }

        if (nebulaDuration >= 1) {
          pushStyle();
          tint(255, nebulaDuration); // Nebula fading  
          image(nebula, position.x + xDifference, position.y + xDifference, 5 + explosionX, 2 + explosionY);
          popStyle();
        }

        if (nebulaDuration >= 0) {
          nebulaDuration -= 4;
        }
  
        // VARIABLE CHANGES OF THE STAR
        image(image, position.x, position.y, diameter, diameter); // Displays the White dwarf
        diameter = sizeOfCore - growingRate; // Controls the diameter of the white dwarf
        mass = 700;
        //
  
        if (explosionX < 300) { // Planetary Nebulae Expansion 200
//          explosionX += 1.2;
//          explosionY += 1;
          explosionX += 4.2;
          explosionY += 4;
        }
        
      } else if (type == StellarObject.BLUE) {
         
        if (pulsarOrHole >= 0.5) { // Neutron Star
          
          adjustStarLimit();
          
          if(neutronPrompt == true && promptState == 4 && recentCreation) { // Advance Prompt
            promptState += 1;
            promptWait = promptWaitTime;
          }
          
          if (neutronOrPulsar >= 0.7) { // Special kind of Neutron Star called Pulsar
            adjustStarLimit();
            
            pushStyle();
            strokeWeight(1);
            stroke(255);
            noFill();
            strokeWeight(0.7);
            strokeCap(ROUND);
            for (int i = 0; i < 4; i++) {
              int randomStuff = int(random(40, 50));
              ellipseMode(CENTER);
              ellipse((position.x + int(random(-15, 15))), position.y, randomStuff, randomStuff);
            }
            popStyle();
          }


          // VARIABLE CHANGES OF THE STAR
          partColor = color(76, 44, 183);  
          neutronStarText.update(position.x, position.y);
          diameter = sizeOfCore - growingRate; // Controls diameter of neutron star
          mass = 3000;
          image = neutronStar;
          //
          
          pushMatrix(); 
          imageMode(CENTER);
          translate(position.x, position.y);
          rotate(radians(neutronRotate));
          image(image, 0, 0, diameter, diameter); // Displays image of neutron star
          neutronRotate += 70;
          popMatrix();
                
        } else { // Create Black Hole
          if(blackholePrompt == true && promptState == 3 && recentCreation) { // Advance Prompt
            promptState += 1; 
            promptWait = promptWaitTime;
        }
          addBlackHoles.add( new BlackHole(new PVector(position.x, position.y), 100, 8000));
          this.Destroy();
        }
      }
      
      if(recentCreation == true) {
        recentCreation = false; // The star has recently been created
      }
      
    }
  }
  
  
  
  void adjustStarLimit() {
    if(deletedFromList == false) { // Allows to add more stars to the system
//      numberOfStars -= 1; // Allow other stars to be placed
      afterStar +=1;
      deletedFromList = true;
    }
  }
  
  void goSupernova() {
    pushStyle();
//    fill(255, 122, 122, explosionY + 255);
//    ellipseMode(CENTER);
    imageMode(CENTER);
    tint(255, explosionY + 255);
//    ellipse(position.x, position.y, diameter + explosionX, diameter + explosionX);
    image(nova, position.x, position.y, diameter + explosionX, diameter + explosionX);
    if(explosionX <= 650) {
      explosionX += 25;
      explosionY -= 2;
    }
    popStyle();
    
    if(nebulaePrompt == true && promptState == 1 && recentCreation) { // Advance Prompt
            promptState += 1; 
            promptWait = promptWaitTime;
    }
  }
  
  void AgeDisplay() {
    if(timePassing == true) {
      pushStyle(); 
      textAlign(CENTER);
      rectMode(CENTER);
      fill(0);
      stroke(255);
      strokeWeight(2);
//      rect(position.x, position.y + (diameter / 2), 380, 30);
      fill(35,78,90);
//      text("Age of Star: " + lifeDisplay + " millions of years", position.x, position.y + (diameter / 2));
//      text("Age of Star: " + nfc(lifeDisplay, 2) + " millions of years", position.x, position.y + (diameter / 2));
      popStyle();
    }
  }

  void UpdateFromTuio(TuioObject tuio) {
    position.x = tuio.getScreenX(width);
    position.y = tuio.getScreenY(height);
  }

  void CreateFromTuio(TuioObject tuio) {
    type = StellarObject.YELLOW;
    if (idToType.containsKey(tuio.getSymbolID())) {
      type = idToType.get(tuio.getSymbolID()); 
      println(type);
    } else {
      println("idToType does not have key " + tuio.getSymbolID());
    }

    switch(type) { // Change back the lifetimes

    case YELLOW:
      mass = 5000;
      diameter = star.width;
      image = star;
      nebula = nebulaBlue;
      lifeOfStar = 5000; // 5000
      lifeOfStar = 100;
//      stageOfStar = 5000;
      growingRate = 0.035;
      partColor = color(255, 255, 158);
      nebulaeColor = int(random(1, 5));
      break;
    case RED_DWARF:
      mass = 4000;
      diameter = redDwarf.width;
      image = redDwarf;
      nebula = nebulaYellow;
      lifeOfStar = 15000; // 15000
//      stageOfStar = 15000;
      growingRate = 0.002;
      partColor = color(255, 45, 45);
      nebulaeColor = int(random(1, 5));
      break;
    case BLUE:
      mass = 7000;
      diameter = blueStar.width;
      image = blueStar;
      nebula = nebulaPurple;
      lifeOfStar = 1000; // 1000
//      lifeOfStar = 100; // 1000
//      stageOfStar = 1000;
      growingRate = 0.2;
      partColor = color(56, 165, 255);
      pulsarOrHole = random(0, 1);
      neutronOrPulsar = random(0, 1);
//      nebulaeColor = int(random(1, 4));
      break;
      default:
      break;
    }
  }

  void checkHover () {
    PVector mousePos = new PVector(mouseX, mouseY);
    float dis = dist(position.x, position.y, mousePos.x, mousePos.y);
    if ( dis < 60) {
      isOver = true;
      addPlanet();
    } else {
      isOver = false;
    }

    if (release && isOver) {
      position.x = mouseX;
      position.y = mouseY;
    }
  }
  
  void evaporate() { // Evaporate after creation / White Dwarf / Neutron star
    if(lifeOfStar == 0) {
      evaporation++;
      if(evaporation >= 3000) { // 3000
        afterStar -= 1;
        this.Destroy();
      }
    }
  }
  
  
  void starShreding() { // Active when Star is close to a Black Hole or Neutron Star
    
    for (BlackHole hole : allBlackHoles) {
      
      //if ( dist(position.x, position.y, hole.position.x, hole.position.y) >= ((diameter + hole.diameter) /2) + 220 ) { 
      //  beingShredded = false;  
      //  continue;
      //}
      
      if(beingShredded) {
        completeLifeOfStar -= 0.5;
        for (int i = 0; i < 7; i++) { // 12 particles
          addParticles.add( new SpaceParticle(new PVector(position.x + (random(-diameter, diameter)) / 3, position.y + (random(-diameter, diameter)) / 3), 1.7, 0, partColor)); // 1.5 diameter      
        }
        continue;
      }
      
      if(lifeOfStar >= 0) { // Shred parameters when star is alive
        if ( dist(position.x, position.y, hole.position.x, hole.position.y) <= ((diameter + hole.diameter) /2) + shredDistance ) { 
          beingShredded = true;        
          completeLifeOfStar -= 1;
          for (int i = 0; i < 7; i++) {
            addParticles.add( new SpaceParticle(new PVector(position.x + (random(-diameter, diameter)) / 3, position.y + (random(-diameter, diameter)) / 3), 2, 1.7, partColor));          
          }
        }
      }
      
      if(lifeOfStar < 0) { // Shred parameters when star is dead
        if ( dist(position.x, position.y, hole.position.x, hole.position.y) <= ((diameter + hole.diameter) /2) + shredDistance) { 
          beingShredded = true;        
          completeLifeOfStar -= 1;
          for (int i = 0; i < 7; i++) {
            addParticles.add( new SpaceParticle(new PVector(position.x + (random(-diameter, diameter)) / 3, position.y + (random(-diameter, diameter)) / 3), 2, 1.7, partColor));          
          }
        }
      }
      
    }
    
    for (Star hole : allStars) {
      
      //if ( dist(position.x, position.y, hole.position.x, hole.position.y) >= ((diameter + hole.diameter) /2) + 220 && hole.image == neutronStar) { 
      //  if (hole == this) continue;
      //  beingShredded = false;  
      //  continue;
      //}
      
      if(beingShredded) {
        completeLifeOfStar -= 0.5;
        for (int i = 0; i < 6; i++) { // 12 particles
          addParticles.add( new SpaceParticle(new PVector(position.x + (random(-diameter, diameter)) / 3, position.y + (random(-diameter, diameter)) / 3), 1.7, 0, partColor)); // 1.5 diameter      
        }
        continue;
      }
      
      if ( dist(position.x, position.y, hole.position.x, hole.position.y) <= ((diameter + hole.diameter) /2) + shredDistance && hole.image == neutronStar && this.image != neutronStar) { 
        if (hole == this) continue;
        beingShredded = true;        
        completeLifeOfStar -= 1;
        for (int i = 0; i < 7; i++) {
          addParticles.add( new SpaceParticle(new PVector(position.x + (random(-diameter, diameter)) / 3, position.y + (random(-diameter, diameter)) / 3), 2, 1.7, partColor));          
        }
      }
      
    }
    
    if(beingShredded) {
      if(shredPrompt == true && promptState == 0 && recentCreation) { // Advance Prompt
            promptState += 1;
            promptWait = promptWaitTime;
        }
    }
    
  }
  
  void addPlanet() {
    PVector mousePos = new PVector(mouseX, mouseY);
    float dis = dist(position.x, position.y, mousePos.x, mousePos.y);
    if (dis < (this.diameter / 2) && mousePressed == true && lifeOfStar > 0) {
      addPlanets.add( new Planet(new PVector(position.x, position.y), 18, 1000, new PVector(0,0)));  
    }
  }
  
  void collapseNeutron() { // When a neutron star receives too much mass it collides into a black hole.
    if(matter >= 500) {
      addBlackHoles.add( new BlackHole(new PVector(position.x, position.y), 100, 8000));
      this.Destroy();  
    }
  }
    
}