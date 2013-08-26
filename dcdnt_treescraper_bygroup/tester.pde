
int testGroup = 200;
int stripNumToTest = 0;
int curNumPixel = 0;
int maxCyclesToHold = 20;
int curCycle = 0;

void test() {
  // scrape for the strips
  loadPixels();
  
   TreeForrest ts = mainTreeForrest;
  
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips(testGroup);
    for (Strip s : strips) {
        sn = s.getStripNumber();
        trs = ts.getStrip(gn, sn);
        if (trs != null) {
          for (int pixel=0; pixel < trs.getNumPixels(); pixel++) {
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
      println("Testing group " + testGroup + " strip " + stripNumToTest + " pixel " + curNumPixel);
    }
  }
  updatePixels();
}

