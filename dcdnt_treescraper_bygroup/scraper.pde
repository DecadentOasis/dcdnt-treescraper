
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
int[] groups = new int[] {
  200, 201, 202, 203, 205, 206, 207, 208, 209, 100, 101, 300
};
int gn = 200;
color c;
TreeStrip trs;

void scrape() {
  // scrape for the strips
  loadPixels();
  
  TreeForrest ts = mainTreeForrest;
  
  if (testObserver.hasStrips) {
    registry.startPushing();
    for (int gn : groups) {
      List<Strip> strips = registry.getStrips(gn);
      println("Looking for group "  + gn);
      for (Strip s : strips) {
        sn = s.getStripNumber();
        trs = ts.getStrip(gn, sn);
        println("Looking for group "  + gn + " strip " + sn);
        if (trs != null) {
          for (PixelBlock pb : trs.getPixelBlocks()) {            
            x = pb.getXs()[0];
            y = pb.getYs()[0];
            c = weighted_get(x, y, 1);
            s.setPixel(c, n);         
            n++;
          }
          n = 0;
        }
      }
    }
  }
  updatePixels();
}

