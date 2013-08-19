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
int canvasW = 320;
int canvasH = 240;
TestObserver testObserver;
TreeForrest ts;

int radius = 5;
float theta = 3.0;

void setup() {
  ts = new TreeForrest();
  ShortTree tree = new ShortTree(0, 0, 160, 110, 0, 60, 4, 24, 30, 1, 30);
  
  /*
  RegularTree tree = new RegularTree();
  tree.addStrip(new RegularStrip(0, 0, 160, 110, true, 18, 0));
  tree.addStrip(new RegularStrip(0, 1, 160, 110, true, 18, 45));
  tree.addStrip(new RegularStrip(0, 2, 160, 110, true, 18, 90));
  tree.addStrip(new RegularStrip(0, 3, 160, 110, true, 18, 135));
  */
  ts.addTree(tree);
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
  scrape();
}

void stop()
{
  super.stop();
}

