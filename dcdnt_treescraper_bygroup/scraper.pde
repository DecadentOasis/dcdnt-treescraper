
color weighted_get(int xpos, int ypos, int radius) {
  int red, green, blue;
  int xoffset, yoffset;
  int pixels_counted;

  color thispixel;


  red = green = blue = pixels_counted = 0;

  for (xoffset=-radius; xoffset<radius; xoffset++) {
    for (yoffset=-radius; yoffset<radius; yoffset++) {
      int x = xpos+xoffset;
      int y = ypos+yoffset;
      if (x > width || x < 0)
        continue;
      if (y > height || y < 0)
        continue;
      
      pixels_counted ++;
      thispixel = get(x, y);
      red += red(thispixel);
      green += green(thispixel);
      blue += blue(thispixel);
    }
  }
  if (pixels_counted > 0)
    return color(red/pixels_counted, green/pixels_counted, blue/pixels_counted);
  return color(0, 0, 0);
}

int pn, sn, x, y, n = 0;
int gn = 0;
color c;
TreeStrip trs;

void scrape() {
  // scrape for the strips
  loadPixels();
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips(gn);
    for (Strip s : strips) {
      sn = s.getStripNumber();
      trs = ts.getStrip(gn, sn);
      if (trs != null) {
        for (PixelBlock pb : trs.getPixelBlocks()) {            
          x = pb.getXs()[0];
          y = pb.getYs()[0];
          c = get(x,y);
          if (n == 9) {
            System.out.println("R " + red(c) + " B " + blue(c) + " G " + green(c) + " # " + c);
          }
          s.setPixel(c, n);         
          n++;
        }
        n = 0;
      } 
    }
  }
  updatePixels();
}

