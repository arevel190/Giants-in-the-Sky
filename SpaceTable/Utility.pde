public void Popup(PVector position, String[] info) {
  
  int textSize = 12;
  textSize(textSize);
  int boxHeight = (info.length + 2) * textSize;
  int boxWidth = textSize;
  
  for(int s = 0; s<info.length; s++){
    boxWidth = max(boxWidth, (int)textWidth(info[s]) + textSize * 2);
  }
  

  fill(255);
  rectMode(CORNER);
  pushMatrix();
  translate((position.x + boxWidth >= width ? position.x-boxWidth : position.x), (position.y - boxHeight <= 0 ? position.y : position.y-boxHeight));
  rect(0, 0, boxWidth, boxHeight);
  
  textAlign(LEFT, TOP);
  fill(0);

  for(int i = 0; i<info.length; i++){
    
    translate(0,textSize);
    text(info[i],textSize,0);
  }
  
  popMatrix();

  
}