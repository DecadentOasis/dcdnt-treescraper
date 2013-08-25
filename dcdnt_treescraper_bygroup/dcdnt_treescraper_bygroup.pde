// Syphon client for PixelPusher
// by jas@heroicrobot.com
//
// refactored by Matt Stone
// evil@heroicrobot.com
//
// then universally remonstered by jas again
//
// vaguely based on
//
// Fancy FFT of the song
// Erin K 09/20/08
// RobotGrrl.com
// ------------------------
// Based off the code by Tom Gerhardt
// thomas-gerhardt.com
import codeanticode.syphon.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.*;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

boolean use_weighted_get = true;

SyphonClient client;
PGraphics canvas;

boolean ready_to_go = true;
int lastPosition;
int canvasW = 1024;
int canvasH = 768;
TestObserver testObserver;
TreeForrest ts;

int radius = 5;
float theta = 3.0;

int smallTreeSpacing = 5;
int sceneIndex = 0;
ShortTree shortTree;
RegularTree bigtree;

void setup() {
  ts = new TreeForrest();

  // tree 200, strip 0
   shortTree = new ShortTree(200, 0, 50, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 200, strip 1
  shortTree = new ShortTree(200, 1, 50, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 200, strip 2
  shortTree = new ShortTree(200, 2, 100, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 200, strip 3
  shortTree = new ShortTree(200, 3, 100, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
  
  // tree 201, strip 0
  shortTree = new ShortTree(201, 0, 150, 200, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 201, strip 1
  shortTree = new ShortTree(201, 1, 150, 250, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 201, strip 2
  shortTree = new ShortTree(201, 2, 200, 200, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 201, strip 3
  shortTree = new ShortTree(201, 3, 200, 250, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
   // tree 202, strip 0
  shortTree = new ShortTree(202, 0, 350, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 202, strip 1
  shortTree = new ShortTree(202, 1, 350, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 202, strip 2
  shortTree = new ShortTree(202, 2, 400, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 202, strip 3
  shortTree = new ShortTree(202, 3, 400, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
  // tree 203, strip 0
  shortTree = new ShortTree(203, 0, 650, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 203, strip 1
  shortTree = new ShortTree(203, 1, 650, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 203, strip 2
  shortTree = new ShortTree(203, 2, 700, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 203, strip 3
  shortTree = new ShortTree(203, 3, 700, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
  // tree 205, strip 0
  shortTree = new ShortTree(205, 0, 900, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 205, strip 1
  shortTree = new ShortTree(205, 1, 900, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 205, strip 2
  shortTree = new ShortTree(205, 2, 950, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 205, strip 3
  shortTree = new ShortTree(205, 3, 950, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
  // tree 204, strip 0
  shortTree = new ShortTree(204, 0, 800, 250, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 204, strip 1
  shortTree = new ShortTree(204, 1, 800, 300, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 204, strip 2
  shortTree = new ShortTree(204, 2, 850, 250, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 204, strip 3
  shortTree = new ShortTree(204, 3, 850, 300, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
    // tree 206, strip 0
  shortTree = new ShortTree(206, 0, 750, 450, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 205, strip 1
  shortTree = new ShortTree(206, 1, 750, 500, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 205, strip 2
  shortTree = new ShortTree(206, 2, 800, 450, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 205, strip 3
  shortTree = new ShortTree(206, 3, 800, 500, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
  // tree 207, strip 0
  shortTree = new ShortTree(207, 0, 900, 450, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 207, strip 1
  shortTree = new ShortTree(207, 1, 900, 500, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 207, strip 2
  shortTree = new ShortTree(207, 2, 950, 450, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 207, strip 3
  shortTree = new ShortTree(207, 3, 950, 500, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
  // tree 208, strip 0
  shortTree = new ShortTree(208, 0, 800, 600, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 208, strip 1
  shortTree = new ShortTree(208, 1, 800, 650, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 208, strip 2
  shortTree = new ShortTree(208, 2, 850, 600, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 208, strip 3
  shortTree = new ShortTree(208, 3, 850, 650, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
  
  // tree 100, strip 0-4
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(100, 0, 360, 310, true, 240, 0));
  bigtree.addStrip(new RegularStrip(100, 1, 360, 310, true, 240, 45));
  bigtree.addStrip(new RegularStrip(100, 2, 360, 310, true, 240, 90));
  bigtree.addStrip(new RegularStrip(100, 3, 360, 310, true, 240, 135));
  ts.addTree(bigtree);
  
  // tree 101, strip 0-4
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(101, 0, 560, 310, true, 240, 0));
  bigtree.addStrip(new RegularStrip(101, 1, 560, 310, true, 240, 45));
  bigtree.addStrip(new RegularStrip(101, 2, 560, 310, true, 240, 90));
  bigtree.addStrip(new RegularStrip(101, 3, 560, 310, true, 240, 135));
  ts.addTree(bigtree);
  
  // tree 102, strip 0-4
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(102, 0, 460, 510, true, 240, 0));
  bigtree.addStrip(new RegularStrip(102, 1, 460, 510, true, 240, 45));
  bigtree.addStrip(new RegularStrip(102, 2, 460, 510, true, 240, 90));
  bigtree.addStrip(new RegularStrip(102, 3, 460, 510, true, 240, 135));
  ts.addTree(bigtree);


  size(canvasW, canvasH, P3D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  background(0);
  client = new SyphonClient(this, "Modul8", "Main View");
}




void draw() {
  if (client.available()) {
    canvas = client.getGraphics(canvas);
    image(canvas, 0, 0, width, height);
  }  
  //scrape();
  drawTrees();
}

void stop()
{
  super.stop();
}

