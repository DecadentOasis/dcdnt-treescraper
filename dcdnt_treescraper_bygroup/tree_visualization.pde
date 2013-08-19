
color [] colors = new color[] {color(255,128,0), color(0,128,0), color(0,128,255), color(255,0,0), color(0,255,0), color(0,0,255), color(255,0,128), color(128,255,0), color(128,0,255), color(255,128,128)};

void drawTrees()
{
  noStroke();
  fill(255,255,255);
  rect(0,0,800,600);  
  textSize(16);
  
  int pixelsPlaced = 0;
    for (Tree tree : ts.getTrees()) {
      for (TreeStrip s : tree.getStrips()) {
        int [] [] xCoordsBlock = s.getPixelXCoords();
        int [] [] yCoordsBlock = s.getPixelYCoords();
        fill(colors[pixelsPlaced++ % colors.length]);
        text (s.getPusherNum() + "_" + s.getStripNum(),xCoordsBlock[0][0], yCoordsBlock[0][0]);
        if (xCoordsBlock!=null && yCoordsBlock!=null && xCoordsBlock.length==yCoordsBlock.length) {   
          for (int i=0; i < xCoordsBlock.length; i++) {
            int [] xCoords = xCoordsBlock[i];
            int [] yCoords = yCoordsBlock[i];
            for (int coordIndex=0; coordIndex < xCoords.length; coordIndex++) {
              rect(xCoords[coordIndex], yCoords[coordIndex],1,1);  
            }
          }
        }
      }
    }
}
