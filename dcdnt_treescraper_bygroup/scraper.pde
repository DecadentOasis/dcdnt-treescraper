
color weighted_get(int xpos, int ypos, int radius) {
  int red, green, blue;
  int xoffset, yoffset;
  int pixels_counted;

  color thispixel;


  red = green = blue = pixels_counted = 0;

  for (xoffset=-radius; xoffset<radius; xoffset++) {
    for (yoffset=-radius; yoffset<radius; yoffset++) {

      pixels_counted ++;
      thispixel = get(xpos + xoffset, ypos + yoffset);
      red += red(thispixel);
      green += green(thispixel);
      blue += blue(thispixel);
    }
  }
  return color(red/pixels_counted, green/pixels_counted, blue/pixels_counted);
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
    List<Strip> strips = registry.getStrips();
    for (Strip s : strips) {
      sn = s.getStripNumber();
      trs = ts.getStrip(gn, sn);
      //trs = ts.getStrip(0, 0);
      if (trs != null) {
        for (PixelBlock pb : trs.getPixelBlocks()) {            
          x = pb.getXs()[0];
          y = pb.getYs()[0];
          c = weighted_get(x, y, 20);
          System.out.println("pn " + pn + " sn " + sn + " X " + x + " Y " + y + " color " + red(c) + " pixelno " + n + " l " + s.getLength());
          s.setPixel(c, n);         
          n++;
        }
        n = 0;
      } 
    }
  }
  updatePixels();
}

