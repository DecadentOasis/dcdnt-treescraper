
int testGroup = 210;
int stripNumToTest = 3;
int curNumPixel = 0;
int maxCyclesToHold = 5;
int curCycle = 0;

void test() {
  // scrape for the strips
  loadPixels();
  
   TreeForrest ts = mainTreeForrest;
  
  if (testObserver.hasStrips) {
    println("Testing group " + testGroup + " strip " + stripNumToTest + " pixel " + curNumPixel);

    registry.startPushing();
    List<Strip> strips = registry.getStrips(testGroup);
    for (Strip s : strips) {
        sn = s.getStripNumber();
        trs = ts.getStrip((testGroup), sn);
        if (trs != null) {
          int numPixelsOnStrip = trs.getNumPixels();
          if (curNumPixel>numPixelsOnStrip) {
            curNumPixel = 0;
          }
          for (int pixel=0; pixel < numPixelsOnStrip; pixel++) {
            if (sn==stripNumToTest && pixel==curNumPixel) {
              s.setPixel(color(255,255,255), pixel);
            } else {
              s.setPixel(color(0,0,0), pixel);
            }
          }
        }
    }

    // test if we need to advance to new pixel
    curCycle++;
    if (curCycle>maxCyclesToHold) {
      curCycle=0;
      curNumPixel++;
    }
  }
  updatePixels();
}

