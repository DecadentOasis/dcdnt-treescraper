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
TreeForrest mainTreeForrest = new TreeForrest();

int radius = 5;
float theta = 3.0;

int smallTreeSpacing = 5;
int smallTreeOverlaySpacing = 30;
int overlayCenterX = 130;
int overlayCenterY = 640;
ShortTree shortTree;
RegularTree bigtree;


int sceneIndex = 0;
// scene 0 - short spread out, big spread out
// scene 1 - short spread out, big overlay
// scene 2 - short overlay, big spread out
// scene 3 - big overlay, big overlay
TreeForrest scene0 = new TreeForrest();
TreeForrest scene1 = new TreeForrest();
TreeForrest scene2 = new TreeForrest();
TreeForrest scene3 = new TreeForrest();

void createSpreadoutShortTrees(TreeForrest ts) {
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
  
  
  // tree 202, strip 0
  shortTree = new ShortTree(202, 0, 150, 400, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 202, strip 1
  shortTree = new ShortTree(202, 1, 150, 450, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 202, strip 2
  shortTree = new ShortTree(202, 2, 200, 400, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 202, strip 3
  shortTree = new ShortTree(202, 3, 200, 450, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
   // tree 201, strip 0
  shortTree = new ShortTree(201, 0, 350, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 201, strip 1
  shortTree = new ShortTree(201, 1, 350, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 201, strip 2
  shortTree = new ShortTree(201, 2, 400, 50, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 201, strip 3
  shortTree = new ShortTree(201, 3, 400, 100, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
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
  
  // tree 206, strip 0
  shortTree = new ShortTree(206, 0, 800, 250, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 206, strip 1
  shortTree = new ShortTree(206, 1, 800, 300, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 206, strip 2
  shortTree = new ShortTree(206, 2, 850, 250, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 206, strip 3
  shortTree = new ShortTree(206, 3, 850, 300, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
    // tree 208, strip 0
  shortTree = new ShortTree(208, 0, 750, 450, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 208, strip 1
  shortTree = new ShortTree(208, 1, 750, 500, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 208, strip 2
  shortTree = new ShortTree(208, 2, 800, 450, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 208, strip 3
  shortTree = new ShortTree(208, 3, 800, 500, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
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
  
  // tree 209, strip 0
  shortTree = new ShortTree(209, 0, 800, 600, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 209, strip 1
  shortTree = new ShortTree(209, 1, 800, 650, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 209, strip 2
  shortTree = new ShortTree(209, 2, 850, 600, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 209, strip 3
  shortTree = new ShortTree(209, 3, 850, 650, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  
    // tree 210, strip 0
  shortTree = new ShortTree(210, 0, 100, 200, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 210, strip 1
  shortTree = new ShortTree(210, 1, 100, 250, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 210, strip 2
  shortTree = new ShortTree(210, 2, 150, 200, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
  // tree 210, strip 3
  shortTree = new ShortTree(210, 3, 150, 250, 0, 60, 4, 24, smallTreeSpacing, 1, smallTreeSpacing);
  ts.addTree(shortTree);
}

void createOverlayShortTrees(TreeForrest ts) {
    // tree 200, strip 0
   shortTree = new ShortTree(200, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 200, strip 1
  shortTree = new ShortTree(200, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 200, strip 2
  shortTree = new ShortTree(200, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 200, strip 3
  shortTree = new ShortTree(200, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  
  
  // tree 201, strip 0
  shortTree = new ShortTree(201, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 201, strip 1
  shortTree = new ShortTree(201, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 201, strip 2
  shortTree = new ShortTree(201, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 201, strip 3
  shortTree = new ShortTree(201, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  
   // tree 202, strip 0
  shortTree = new ShortTree(202, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 202, strip 1
  shortTree = new ShortTree(202, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 202, strip 2
  shortTree = new ShortTree(202, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 202, strip 3
  shortTree = new ShortTree(202, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  
  // tree 203, strip 0
  shortTree = new ShortTree(203, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 203, strip 1
  shortTree = new ShortTree(203, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 203, strip 2
  shortTree = new ShortTree(203, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 203, strip 3
  shortTree = new ShortTree(203, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  
  // tree 205, strip 0
  shortTree = new ShortTree(205, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 205, strip 1
  shortTree = new ShortTree(205, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 205, strip 2
  shortTree = new ShortTree(205, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 205, strip 3
  shortTree = new ShortTree(205, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
    
    // tree 206, strip 0
  shortTree = new ShortTree(206, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 205, strip 1
  shortTree = new ShortTree(206, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 205, strip 2
  shortTree = new ShortTree(206, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 205, strip 3
  shortTree = new ShortTree(206, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  
  // tree 207, strip 0
  shortTree = new ShortTree(207, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 207, strip 1
  shortTree = new ShortTree(207, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 207, strip 2
  shortTree = new ShortTree(207, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 207, strip 3
  shortTree = new ShortTree(207, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  
  // tree 208, strip 0
  shortTree = new ShortTree(208, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 208, strip 1
  shortTree = new ShortTree(208, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 208, strip 2
  shortTree = new ShortTree(208, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 208, strip 3
  shortTree = new ShortTree(208, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
 
  // tree 209, strip 0
  shortTree = new ShortTree(209, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 209, strip 1
  shortTree = new ShortTree(209, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 209, strip 2
  shortTree = new ShortTree(209, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 209, strip 3
  shortTree = new ShortTree(209, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);  
 
  // tree 210, strip 0
  shortTree = new ShortTree(210, 0, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 210, strip 1
  shortTree = new ShortTree(210, 1, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 210, strip 2
  shortTree = new ShortTree(210, 2, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);
  // tree 210, strip 3
  shortTree = new ShortTree(210, 3, overlayCenterX, overlayCenterY, 0, 60, 4, 24, smallTreeOverlaySpacing, 1, smallTreeOverlaySpacing);
  ts.addTree(shortTree);   
}


void createSpreadoutBigTrees(TreeForrest ts) {
  // tree 100, strip 0-3
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(100, 0, 400, 310, true, 240, 0));
  bigtree.addStrip(new RegularStrip(100, 1, 400, 310, true, 240, 45));
  bigtree.addStrip(new RegularStrip(100, 2, 400, 310, true, 240, 90));
  bigtree.addStrip(new RegularStrip(100, 3, 400, 310, true, 240, 135));
  ts.addTree(bigtree);
  
  // tree 100, strip 4-7
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(100, 4, 600, 310, true, 240, 0));
  bigtree.addStrip(new RegularStrip(100, 5, 600, 310, true, 240, 45));
  bigtree.addStrip(new RegularStrip(100, 6, 600, 310, true, 240, 90));
  bigtree.addStrip(new RegularStrip(100, 7, 600, 310, true, 240, 135));
  ts.addTree(bigtree);
  
  // tree 101, strip 0-3
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(101, 0, 500, 510, true, 240, 0));
  bigtree.addStrip(new RegularStrip(101, 1, 500, 510, true, 240, 45));
  bigtree.addStrip(new RegularStrip(101, 2, 500, 510, true, 240, 90));
  bigtree.addStrip(new RegularStrip(101, 3, 500, 510, true, 240, 135));
  ts.addTree(bigtree);
}


void createOverlayBigTrees(TreeForrest ts) {
  // tree 100, strip 0-3
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(100, 0, overlayCenterX, overlayCenterY, true, 240, 0));
  bigtree.addStrip(new RegularStrip(100, 1, overlayCenterX, overlayCenterY, true, 240, 45));
  bigtree.addStrip(new RegularStrip(100, 2, overlayCenterX, overlayCenterY, true, 240, 90));
  bigtree.addStrip(new RegularStrip(100, 3, overlayCenterX, overlayCenterY, true, 240, 135));
  ts.addTree(bigtree);
  
  // tree 101, strip 4-7
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(100, 4, overlayCenterX, overlayCenterY, true, 240, 0));
  bigtree.addStrip(new RegularStrip(100, 5, overlayCenterX, overlayCenterY, true, 240, 45));
  bigtree.addStrip(new RegularStrip(100, 6, overlayCenterX, overlayCenterY, true, 240, 90));
  bigtree.addStrip(new RegularStrip(100, 7, overlayCenterX, overlayCenterY, true, 240, 135));
  ts.addTree(bigtree);
  
  // tree 101, strip 0-3
  bigtree = new RegularTree();
  bigtree.addStrip(new RegularStrip(101, 0, overlayCenterX, overlayCenterY, true, 240, 0));
  bigtree.addStrip(new RegularStrip(101, 1, overlayCenterX, overlayCenterY, true, 240, 45));
  bigtree.addStrip(new RegularStrip(101, 2, overlayCenterX, overlayCenterY, true, 240, 90));
  bigtree.addStrip(new RegularStrip(101, 3, overlayCenterX, overlayCenterY, true, 240, 135));
  ts.addTree(bigtree);
}

void addLoungeStrips(TreeForrest ts) {
   // what is the group for these strips
   // straight lines 103, strip 0-4
  bigtree = new RegularTree();
  bigtree.addStrip(new HoldedStrip(300, 0, 280, 700, 24, 13, 10));
  ts.addTree(bigtree);
}

void setup() {
  // scene 0 - short spread out, big spread out
  scene0 = new TreeForrest();
  createSpreadoutShortTrees(scene0);
  createSpreadoutBigTrees(scene0);
  addLoungeStrips(scene0);

  // scene 1 - short spread out, big overlay
  scene1 = new TreeForrest();
  createSpreadoutShortTrees(scene1);
  createOverlayBigTrees(scene1);
  addLoungeStrips(scene1);

  // scene 2 - short overlay, big spread out
  scene2 = new TreeForrest();
  createOverlayShortTrees(scene2);
  createSpreadoutBigTrees(scene2);
  addLoungeStrips(scene2);
  
  // scene 3 - big overlay, big overlay
  scene3 = new TreeForrest();
  createOverlayShortTrees(scene3);
  createOverlayBigTrees(scene3);
  addLoungeStrips(scene3);
  
  mainTreeForrest = scene0;

  size(canvasW, canvasH, P3D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(false);
  background(0);
  client = new SyphonClient(this, "Modul8", "Main View");
}




void draw() {
  if (keyPressed) {
    if (key == 'z') {
      if (sceneIndex==0) {
        sceneIndex=2;
        mainTreeForrest = scene2;
      } else if (sceneIndex==1) {
        sceneIndex=3;
        mainTreeForrest = scene3;
      }
    } else if (key == 'a') {
     if (sceneIndex==2) {
        sceneIndex=0;
        mainTreeForrest = scene0;
      } else if (sceneIndex==3) {
        sceneIndex=1;
        mainTreeForrest = scene1;
      }
    } else if (key == 'x') {
     if (sceneIndex==2) {
        sceneIndex=3;
        mainTreeForrest = scene3;
      } else if (sceneIndex==0) {
        sceneIndex=1;
        mainTreeForrest = scene1;
      }
    } else if (key == 's') {
     if (sceneIndex==3) {
        sceneIndex=2;
        mainTreeForrest = scene2;
      } else if (sceneIndex==1) {
        sceneIndex=0;
        mainTreeForrest = scene0;
      }
    }
  }
  if (client.available()) {
    canvas = client.getGraphics(canvas);
    image(canvas, 0, 0, width, height);
  }
  scrape();
  //test();
  //drawTrees();
}

void stop()
{
  super.stop();
}

