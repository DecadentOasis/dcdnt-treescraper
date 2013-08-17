
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
color c;
TreeStrip trs;

void scrape() {
  // scrape for the strips
  loadPixels();
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<PixelPusher> ps = registry.getPushers();
    for (PixelPusher p : ps) {
      for (Strip s : p.getStrips()) {
        pn = p.getControllerOrdinal();
        sn = s.getStripNumber();
        trs = ts.getStrip(pn, sn);
        if (trs != null) {
          for (PixelBlock pb : trs.getPixelBlocks()) {            
            x = pb.getXs()[0];
            y = pb.getYs()[0];
            c = weighted_get(x, y, 10);
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

