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
int canvasW = 800;
int canvasH = 600;
TestObserver testObserver;
TreeForrest ts;

int radius = 5;
float theta = 3.0;

void setup() {
  ts = new TreeForrest();
  ShortTree shortTree = new ShortTree(0, 0, 160, 110, 0, 60, 4, 24, 5, 1, 5);
  ts.addTree(shortTree);
//  ShortTree shortTree2 = new ShortTree(0, 0, 500, 300, 0, 60, 4, 24, 30, 1, 30);
//  ts.addTree(shortTree2);
  
  RegularTree bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(1, 0, 360, 410, true, 18, 0));
  bigtree.addStrip(new RegularStrip(1, 1, 360, 410, true, 18, 45));
  bigtree.addStrip(new RegularStrip(1, 2, 360, 410, true, 18, 90));
  bigtree.addStrip(new RegularStrip(1, 3, 360, 410, true, 18, 135));
  
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
  scrape();
  //drawTrees();
}

void stop()
{
  super.stop();
}

