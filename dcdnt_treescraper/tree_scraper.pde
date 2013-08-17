import java.util.ArrayList;

interface Tree {
  public RegularStrip [] getStrips();
}

interface TreeStrip {

  public String getStripName();

  public int getStripNum();

  public PixelBlock [] getPixelBlocks();

  public int getNumPixels();

  /**
   * Returns X coordinates of all pixels in array
   * @return
   */

  public int [] [] getPixelXCoords();
  /**
   * Returns Y coordinates of all pixels in array
   * @return
   */

  public int [] [] getPixelYCoords();
}

/**
 * A single pixel can represent multiple x/y coordinates on the canvas
 * This is useful when using averaging across an area to compute the color for
 * a single physical LED pixel
 */
interface PixelBlock
{
  public int [] getXs();
  public int [] getYs();
}

/**
 * Regular tree where each strip has a number of pixels each with a single x/y coordinate
 * 
 */
static public class RegularTree implements Tree
{
  ArrayList<RegularStrip> strips = new ArrayList<RegularStrip>();

  public void addStrip(RegularStrip s) {
    strips.add(s);
  }

  public RegularStrip [] getStrips() {
    return strips.toArray(new RegularStrip [strips.size()]);
  }
}


/**
 * Short tree consists of only one strip with a center position and a certain number of branches 6 or 8 (common)
 * It has 18 or 24 (common) LEDs on it with each LED representing a certain
 * 
 * The wiring is definitely fucked up as well, see diagrams
 * 
 * The tree has pixels that represent an array of coordinates. We average over those coordinates to determine a color
 * 
 */
static public class ShortTree implements Tree
{

  RegularStrip [] shortStripArray = new RegularStrip [1];

  public ShortTree(
  String stripName, 
  int stripNum, 
  int treeXCenter, // center of tree
  int treeYCenter, // center of tree
  int startingAngle, // starting angle, for example 270 degrees
  int angleIncrement, // angle increment, for example -45 degrees
  int numPixelsPerBranch, // number of pixels per branch, tested with 3
  int totalNumPixels, // total number of pixels per branch, tested with 24
  int distanceToFirstPixelCenter, // spacing until first pixel center
  int pixelSize, // for now pixel is a circle, and this is circle size
  //      int lengthOfEachPixel,  // how much space each pixel takes up in pixels from center
  //      int widthOfEachPixel,  // how much space each pixel takes up in pixels width-wise
  int distanceBetweenPixelCenters  // distance to the next pixel center
  ) {

    shortStripArray[0] = new RegularStrip(stripName, stripNum);

    // prepare initial coordinate
    Point p = new Point(treeXCenter, treeYCenter);
    p.move(distanceToFirstPixelCenter, startingAngle);
    // prepare circle block
    RegularPixelBlock block = makeCirclePixelBlock(pixelSize);

    int currentAngle=startingAngle;
    int pixelsOnCurBranch=0;
    for (int pixelsPlaced = 0; pixelsPlaced < totalNumPixels ; pixelsPlaced++) {

      // we are already on the first pixel, so draw our x/ys
      RegularPixelBlock pixelBlock = block.offSetToCoor(p.getX(), p.getY());
      shortStripArray[0].addPixelBlock(pixelBlock);

      // advance to next position
      p.move(distanceBetweenPixelCenters, currentAngle);

      // place pixel
      pixelsOnCurBranch++;

      // advance angle if needed
      if (pixelsOnCurBranch>=numPixelsPerBranch) {
        pixelsOnCurBranch = 0;
        currentAngle = (360 + currentAngle + angleIncrement) % 360;
        System.out.println("New angle " + currentAngle);
        p = new Point(treeXCenter, treeYCenter);
        p.move(distanceToFirstPixelCenter, currentAngle);
      }
    }

    // and due to extra fucked up nature of this strip, we need to re-order a few elements
    // swapping every 2nd and 3rd elemement
    shortStripArray[0].reorderForShortTree();
  }

  static public RegularPixelBlock makeCirclePixelBlock(int radiusInPixels) {
    ArrayList<Integer> xs = new ArrayList<Integer>();
    ArrayList<Integer> ys = new ArrayList<Integer>();

    // lets assume center of circle is coord 0, 0
    // iterate over 2d space checking if coord is within distance to center
    // allow -/+ 1 extra pixel on both ends
    // this will return negative coordinates, so do not forget to offset to new center
    for (int x=-radiusInPixels; x <= radiusInPixels; x++) {
      for (int y=-radiusInPixels; y <= radiusInPixels; y++) {
        if (distance(x, y, 0, 0)<=radiusInPixels) {
          xs.add(x); 
          ys.add(y);
        }
      }
    }
    int [] xsArray = new int[xs.size()];
    for (int i=0; i < xs.size(); i++) {
      xsArray[i] = xs.get(i);
    }
    int [] ysArray = new int[ys.size()];
    for (int i=0; i < ys.size(); i++) {
      ysArray[i] = ys.get(i);
    }
    return new RegularPixelBlock(xsArray, ysArray);
  }
  public static int distance(int x, int y, int x2, int y2)
  {
    double dx   = Math.abs(x - x2);
    double dy   = Math.abs(y - y2);
    double dist = Math.sqrt( dx*dx + dy*dy ); 
    return (int) dist;
  }
  public RegularStrip [] getStrips() {
    return shortStripArray;
  }
}

/**
 * Regular strip
 * Each pixel corresponds to a single x/y coordinate on canvas
 *
 */
static public class RegularStrip implements TreeStrip
{
  String stripName;
  int stripNum;
  ArrayList<PixelBlock> pixels = new ArrayList<PixelBlock>();

  // precomputed arrays of coordinates for fast access
  int [] [] xCoords;  
  int [] [] yCoords;

  public RegularStrip(String stripName, 
  int stripNum) {
    this.stripName = stripName;
    this.stripNum = stripNum;
  }

  public RegularStrip(String stripName, 
  int stripNum, 
  int x, 
  int y, 
  boolean isXYCenter, 
  int numPixels, 
  double angle) {

    int desiredPixels = numPixels;

    this.stripName = stripName;
    this.stripNum = stripNum;

    double angleInRadians = angle * Math.PI / 180;

    System.out.println("Creating " + numPixels + " pixels");
    int startX = x;
    int startY = y;
    int endX;
    int endY;
    // compute start position and end position
    if (isXYCenter) {
      // take num pixels and div by 2
      // half the strip will go one way, and the other half the other way
      int halfPixels = numPixels/2;
      startX = x + (int)(halfPixels * Math.cos(Math.PI-angleInRadians));
      startY = y + (int)(halfPixels * Math.sin(Math.PI-angleInRadians));
      endX = x + (int)(halfPixels * Math.cos(angleInRadians));
      endY = y - (int)(halfPixels * Math.sin(angleInRadians));
    } 
    else {
      endX = x + (int)(numPixels * Math.cos(angleInRadians));
      endY = y - (int)(numPixels * Math.sin(angleInRadians));
    }

    // create pixels
    line(startX, startY, endX, endY, pixels);
    if (pixels.size()==desiredPixels) {
      // perfect fit
      System.out.println("Got " + pixels.size() + ". Perfect");
    } 
    {
      if (pixels.size()<desiredPixels) {
        // rescale and try again
        int reusePixels = desiredPixels - pixels.size();
        System.out.println("Got " + pixels.size() + " so adding " + reusePixels + " extra pixels");
        double insertionRatio = (double)desiredPixels / pixels.size();
        int insertedPixels = 0;
        for (int i=0; i < pixels.size(); i++) {
          if (Math.floor(insertionRatio * (i - insertedPixels)) > i) {
            PixelBlock curPixel = pixels.get(i);
            pixels.add(i, new RegularPixelBlock(curPixel));
            insertedPixels++;
          }
        }
        // may need to repeat last pixel if still not enough
        if (pixels.size()<desiredPixels) {
          PixelBlock tail = pixels.get(pixels.size()-1);
          pixels.add(new RegularPixelBlock(tail));
          insertedPixels++;
        }
        System.out.println("Was supposed to insert " + reusePixels + " and actually inserted " + insertedPixels);
      } 
      else {
        // trim down
        System.out.println("Trimming down strip from " + pixels.size() + " to " + desiredPixels);
        while (pixels.size ()!=desiredPixels) {
          pixels.remove(pixels.size()-1);
        }
      }
    }
  }
  // line drawing code from
  // http://tech-algorithm.com/articles/drawing-line-using-bresenham-algorithm/
  private static void line(int x, int y, int x2, int y2, ArrayList<PixelBlock> pixelList) {
    int w = x2 - x ;
    int h = y2 - y ;
    int dx1 = 0, dy1 = 0, dx2 = 0, dy2 = 0 ;
    if (w<0) dx1 = -1 ; 
    else if (w>0) dx1 = 1 ;
    if (h<0) dy1 = -1 ; 
    else if (h>0) dy1 = 1 ;
    if (w<0) dx2 = -1 ; 
    else if (w>0) dx2 = 1 ;
    int longest = Math.abs(w) ;
    int shortest = Math.abs(h) ;
    if (!(longest>shortest)) {
      longest = Math.abs(h) ;
      shortest = Math.abs(w) ;
      if (h<0) dy2 = -1 ; 
      else if (h>0) dy2 = 1 ;
      dx2 = 0 ;
    }
    int numerator = longest >> 1 ;
    for (int i=0;i<=longest;i++) {
      pixelList.add(new RegularPixelBlock(x, y));
      numerator += shortest ;
      if (!(numerator<longest)) {
        numerator -= longest ;
        x += dx1 ;
        y += dy1 ;
      } 
      else {
        x += dx2 ;
        y += dy2 ;
      }
    }
  }
  public String getStripName() {
    return stripName;
  }

  public int getStripNum() {
    return stripNum;
  }

  public PixelBlock [] getPixelBlocks() {
    return pixels.toArray(new PixelBlock[pixels.size()]);
  }

  public void addPixelBlock(PixelBlock pixelBlock) {
    pixels.add(pixelBlock);
  }

  public int getNumPixels() {
    return pixels.size();
  }

  /**
   * Returns X coordinates of all pixels in array
   * @return
   */
  public int [] [] getPixelXCoords() {
    if (xCoords==null) {
      xCoords = new int [pixels.size()][];
      for (int i=0; i < pixels.size(); i++) {
        xCoords[i] = pixels.get(i).getXs();
      }
    }
    return xCoords;
  }

  public int [] [] getPixelYCoords() {
    if (yCoords==null) {
      yCoords = new int [pixels.size()][];
      for (int i=0; i < pixels.size(); i++) {
        yCoords[i] = pixels.get(i).getYs();
      }
    }
    return yCoords;
  }

  public void reorderForShortTree() {
    // swap every 2nd and 3rd element
    for (int i=0; i < pixels.size(); i++) {
      if (i % 3 == 0 && i>0) {
        pixels.add(i-1, pixels.remove(i));
      }
    }
  }
}

static public class Point
{
  int x;
  int y;

  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void move(int numPixels, int angle) {
    double angleInRadians = angle * Math.PI / 180;
    x = x + (int)(numPixels * Math.cos(angleInRadians));
    y = y - (int)(numPixels * Math.sin(angleInRadians));
    System.out.println("Moved to " + x + " " + y);
  }

  public int getX() { 
    return x;
  }
  public int getY() { 
    return y;
  }
}
static public class RegularPixelBlock implements PixelBlock
{
  int [] x;
  int [] y;

  public RegularPixelBlock() {
  }
  public RegularPixelBlock(int x, int y) {
    this.x = new int[] {
      x
    };
    this.y = new int[] {
      y
    };
  }
  public RegularPixelBlock(int [] x, int [] y) {
    this.x = x;
    this.y = y;
  }
  public RegularPixelBlock(PixelBlock pixel) {
    this.x = pixel.getXs();
    this.y = pixel.getYs();
  }
  public int [] getXs() { 
    return x;
  }
  public int [] getYs() { 
    return y;
  }

  public RegularPixelBlock offSetToCoor(int newStartX, int newStartY) {
    int [] newX = null, newY = null;
    if (x!=null) {
      newX = new int[x.length];
      for (int i=0; i < x.length; i++) {
        newX[i] = x[i] + newStartX;
      }
    }
    if (y!=null) {
      newY = new int[y.length];
      for (int i=0; i < y.length; i++) {
        newY[i] = y[i] + newStartY;
      }
    }
    return new RegularPixelBlock(newX, newY);
  }
} 

public class TreeForrest {

  public static final int CANVAS_MAX_X_SIZE = 320;
  public static final int CANVAS_MAX_Y_SIZE = 240;

  ArrayList<Tree> trees = new ArrayList<Tree>();

  public void addTree(Tree tree) {
    trees.add(tree);
  }

  public Tree [] getTrees() {
    return trees.toArray(new Tree [trees.size()]);
  }
}

