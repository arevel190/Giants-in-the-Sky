boolean neutronPrompt = false;
boolean nebulaePrompt = false;
boolean blackholePrompt = false;
boolean whiteDwarfPrompt = false;
boolean shredPrompt = false;
int promptState = 0;
float promptWait = 0;
int promptWaitTime = 150;
int promptReset = 0;

class Prompt extends Body {
  
  String interText;
  String promptType;
  color textColor;
  
  Prompt(PVector pos, float diameter, float mass, String text, String type) {
    addPrompts.remove(this);
    position = new PVector();
    position = pos;
    interText = text;
    promptType = type;
    this.diameter = diameter;
    this.mass = mass;
    allPrompts.add(this);
  }
  
  void Update() {
    this.draw();
  }
  
  void Die() {
    allPrompts.remove(this);
    super.Die();
  }
  
  void draw() {
    pushStyle();
    imageMode(CENTER);
    
    if(promptState == 0) {
      image(shredStarPrompt, width/2, yPrompt - 7, 360, 50); 
    } else if(promptState == 1 && promptWait == 1) {
      image(supernovaPrompt, width/2, yPrompt - 7, 360, 50);  
    } else if(promptState == 2 && promptWait == 1) {
      image(whiteStarPrompt, width/2, yPrompt - 7, 360, 50); 
    } else if(promptState == 3 && promptWait == 1) {
      image(holePrompt, width/2, yPrompt - 7, 360, 50); 
    } else if(promptState == 4 && promptWait == 1) {
      image(neutronStarPrompt, width/2, yPrompt - 7, 360, 50); 
    }
    
    if(promptState == 1 && promptWait > 1) { // Show when prompt has been successful
      image(shredStarPromptSucc, width/2, yPrompt - 7, 360, 160); 
    } else if(promptState == 2 && promptWait > 1) {
      image(supernovaPromptSucc, width/2, yPrompt - 7, 360, 160);  
    } else if(promptState == 3 && promptWait > 1) {
      image(whiteStarPromptSucc, width/2, yPrompt - 7, 360, 160); 
    } else if(promptState == 4 && promptWait > 1) {
      image(holePromptSucc, width/2, yPrompt - 7, 360, 160); 
    } else if(promptState == 5 && promptWait > 1) {
      image(neutronStarPromptSucc, width/2, yPrompt - 7, 360, 160); 
    }
               
    popStyle();
  }
  
}


  void AddPrompt(float x, float y, String infoText, String stellarType) { // Function to add interactive prompt
    addPrompts.add( new Prompt(new PVector(x, y), 100, 0, infoText, stellarType)); 
  }
  
  
class Pullout {
  
  float xpos;
  float ypos;
  int increment;
  String text;
 
  Pullout(float xin, float yin, String textIn) {
    xpos = xin;
    ypos = yin;
    increment = 0;
    text = textIn;
  }
  
  void update(float newX, float newY){
    if (increment < 150){
      render(newX, newY);
    }
    addIncrement();
  }
  
  void addIncrement () {
    increment ++;
  }
  
  void render(float xpos, float ypos) {
    pushStyle();
    fill(0);
    stroke(255);
    strokeWeight(1);
    line(xpos, ypos, xpos+50, ypos-50);
    line(xpos+50, ypos-50, xpos+150, ypos-50);
    rect(xpos+70, ypos-150, 200, 100);
    fill(0);
    stroke(0);
    increment ++;
    textAlign(LEFT);
    fill(255);
    textSize(16); 
    text(text, xpos + 90, ypos - 120); 
    popStyle();
  }
  
}

void StarLimitMessage() { // Message when Star limit is reached
  
  if(starLimit) {
    pushStyle(); 
    textAlign(CENTER);
    rectMode(CENTER);
    fill(0);
    stroke(255);
    strokeWeight(2);
    rect(width / 2, height / 2, 500, 200);
    fill(255);
    textSize(20);
    text("You have reached the star limit!", width / 2, height / 2);
    popStyle();
    textLife += 1;
    
    if(textLife >= 50) {
      textLife = 0;
      starLimit = false;
    }
  }
  
}

void HoleLimitMessage() { // Message when Black Hole limit is reached
  
  if(holeLimit) {
    pushStyle(); 
    textAlign(CENTER);
    rectMode(CENTER);
    fill(0);
    stroke(255);
    strokeWeight(2);
    rect(width / 2, height / 2, 500, 200);
    fill(255);
    textSize(20);
    text("You have reached the Black Hole limit!", width / 2, height / 2);
    popStyle();
    holeTextLife += 1;
    
    if(holeTextLife >= 50) {
      holeTextLife = 0;
      holeLimit = false;
    }
  }
  
}

// CONSTANT VARIABLES
int xPrompt = 60;
int yPrompt = 135;
//

void DisplayPrompt() {  
   
  if(shredPrompt == false && promptState == 0) {
    AddPrompt(width / 2 + xPrompt, yPrompt, "", "Shred Star");
    shredPrompt = true;
  } else if(nebulaePrompt == false && promptState == 1 && promptWait == 1) {
    AddPrompt(width / 2 + xPrompt, yPrompt, "", "Planetary Nebula");
    nebulaePrompt = true;
  } else if(whiteDwarfPrompt == false && promptState == 2 && promptWait == 1) {
    AddPrompt(width / 2 + xPrompt, yPrompt, "", "White Dwarf");
    whiteDwarfPrompt = true;
  } else if(blackholePrompt == false && promptState == 3 && promptWait == 1) {
    AddPrompt(width / 2 + xPrompt, yPrompt, "", "Black Hole");
    blackholePrompt = true;
  } else if(neutronPrompt == false && promptState == 4 && promptWait == 1) {
    AddPrompt(width / 2 + xPrompt, yPrompt, "", "Neutron Star");
    neutronPrompt = true;
  } 
  
  if(promptWait > 1) { // Allows to displaying o success message 
    promptWait -= 0.5;  
  }
  
  if(promptState >= 5) { // Resets the prompts once all have been completed
    promptReset++;
    if(promptReset >= 10000) {
      promptReset = 0;
      neutronPrompt = false;
      nebulaePrompt = false;
      blackholePrompt = false;
      whiteDwarfPrompt = false;
      shredPrompt = false;
      promptState = 0;
    }
  }
  
    
}