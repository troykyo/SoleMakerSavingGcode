/* ©Niek van Sleeuwen TU/e 2016
 For the elective Digital Craftsmanship
 Creates Gcode file for the Ultimaker 2 from a series of SVG files with polygon coordinates. 
 SVG files are extracted from a STL file, every SVG file is a 0.3mm layer.
 *********************************************************************************************
 Collisiondetection combined with:
 LINE/LINE COLLISION FUNCTION
 Jeff Thompson // v0.9 // November 2011 // www.jeffreythompson.org
 *********************************************************************************************
 points2edges and Gcode 'generator' written by Loe Feijs;
 *********************************************************************************************
 3D rotation matrix around the centre point of the sole from Glenn Murray, last modifed May 6 2013:
 https://sites.google.com/site/glennmurray/Home/rotation-matrices-and-formulas/rotation-about-an-arbitrary-axis-in-3-dimensions
 ****************************************************************************************
 */


import processing.pdf.*;
//library to find extra points on a Catmull-Rom spline
import AULib.*;


//a few utilities for generating filenames based on day and time:
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

AUCurve MyCurve;
AUCurve Contour;
PtoC C = new PtoC();
contour Con= new contour();
collision Col = new collision();
rotation Rot = new rotation();

PFont regular;
PFont bold;
PFont medium;


PShape cube;

String line[];
String lines[];
String chars[];
String path;
String coords[];
String split[];
String append[];
float coord[][];
String fileName;
String name = "TROY"; //client name

float s = 1; //scale factor for testprinting;
int dx = 3; //per dx pixels a line is drawn to fill the insole.

int i = 189; // start layer 3Dscan
int numSteps = 400; //Number of points to generate the shape (accuracy). 

//calibrated by Loe Feijs
import java.util.Locale;
float DPMM = 2.834646;//dots per mm
//processing has 72 DPI, one inch is 25.4 mm
//so we have 2,834645669 dots per mm  


float footCurve[][] = new float[numSteps][2]; //coordinates 3D scan/SVG file foot
float contourCurve[][] = new float[numSteps][2]; //coordinates contour, as from oneday.shoe (SoleSize 42.5);

//Arrays for the rotation
float currentLayerDraw = 0;
float[][] rContour;
float[][] rContour2;
float[][] rContourFill;
float[][] rFoot;
float[][] rFootFill;

float layercolor = 255;

//replace the 3D image for better viewing
int xplace = 300;
int yplace = 150;

//Mouse settings for the rotation
float MX, MY, lastX, lastY, savedX, savedY, translateX, translateY;
float scale = 1;

String expl = "3D simulation of the written Gcode for the Ultimaker.\nUse the simulation to check the 3D print and create a STL file if you don't have an Ultimaker 2.\n\nCONTROLS:\nUse the arrow keys to move the simulation up, down, left, and right,\nUse the mouse wheel to zoom,\nClick and drag to rotate the simulation.\n\nAXIS:\nThe red line is the X-axis, the green line is the Y-axis, and the blue line is the Z-axis\n\n";

//FSM states as booleans
boolean draw = false; //acceptor state
boolean written = true; //in between state reachable from any state
boolean explanation = true; //initial state
boolean Gcode = false; //acceptor state, substate of draw


//calculate center X and Y coordinates
float Xcen = 0;
float Ycen = 0;
float Zcen = 0;



//Insole coordinates from oneday.shoe, insole size 42.5
float[] X = {0, 0, 167.847, 208.772, 258.33, 320.67, 375.525, 424.576, 483.466, 531.339, 543.054, 530.414, 480.353, 425.422, 382.479, 335.927, 296.062, 149.037, 23.86, -75.922, -175.706, -207.915, -224.852, -169.783, -72.775, 0, 0};
float[] Y = {0, 0, -112.477, -130.146, -148.676, -162.444, -167.7757, -165.417, -151.146, -110.48, -69.466, -16.689, 43.368, 81.507, 102.285, 116.819, 127.903, 172.591, 256.837, 318.601, 305.057, 265.767, 201.351, 115.745, 49.446, 0, 0};




PrintWriter txt;

//Printer settings
float ext = 0; //extrusion step   
int speed = 600;
float layerHeight = 0.3;
float currentLayer = 0;
float extrusionCoefficient = .4;
int retraction = 10;

void setup() {
  println("START WRITING GCODE INSOLE WITH 3D SCAN TROY");
  Locale.setDefault(Locale.US);//so it writes 0.1 instead of 0,1 even in Netherlands
  size(1500, 900, P3D);
  background(255);
  Con.Coord(X, Y);
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd/HH-mm"); 
  Date now = new Date();
  fileName = name + "_" + sdf.format(now) + "_SOLE_" + name + "_ACCU_"+ numSteps + "points_DX_" + dx + "_SCALE_"+ s + ".gcode";
  txt = createWriter(fileName);
  startGcode();
  txt.println("G0  F"+nf(speed) +" Z"+nf(layerHeight)); //Start Layer
  currentLayer = layerHeight;
  //create baselayer of the insole in Gcode
  for (int i = 0; i < 4; i++) {
    Con.contourWrite();
    layerStart();
  }
  bold = createFont("Apercu Bold.otf", 32);
  medium = createFont("Apercu Medium.otf", 32);
  regular = createFont("Apercu Regular.otf", 32);
}

void draw() {

  if (!written) {
    cursor(WAIT);
    C.load();
    //transfers SVG file into coordinates
    C.Points(lines);
    //writes the fill lines to Gcode
    Col.FillWrite(contourCurve, footCurve);
    layerStart();
    //for this scan the layer names go up to "Artboard 1_layer263-01.svg"
    //When the final file is reached save the file
    if (i == 263) {
      i = 263;
      endGcode();
      txt.flush(); 
      txt.close();
      println("File saved as: " + fileName);
      written = true;
      Gcode = true;
      explanation = false;
      draw = true;
    } else {
      i++;
      println(i);
    }
  }// end written

  if (explanation) {
    textFont(regular);
    background(240);
    textSize(20);
    textAlign(CENTER, BOTTOM);
    fill(50);
    text(expl, width/2, height/2);
    fill(250, 237, 100);
    noStroke();
    rect(width/2 + 20, height/2, 280, 100, 10);
    rect(width/2 - 300, height/2, 280, 100, 10);
    fill(255);
    textSize(35);
    textAlign(CENTER, TOP);
    text("Continue", width/2 + 20, height/2 + 35, 280, 100);
    text("Generate Gcode", width/2 - 300, height/2 + 35, 280, 100);
    if ( (written && mouseX > width/2 + 20 && mouseX < width/2 + 300 && mouseY > height/2 && mouseY < height/2 + 100) || (written && mouseX > width/2 - 300 && mouseX < width/2 - 20 && mouseY > height/2 && mouseY < height/2 + 100)) {
      cursor(HAND);
    } else if (written) {
      cursor(ARROW);
    }
    if ( written && mouseX > width/2 + 20 && mouseX < width/2 + 300 && mouseY > height/2 && mouseY < height/2 + 100) {
      fill(250, 237, 100);
      stroke(10, 80);
      strokeWeight(2);
      rect(width/2 + 20, height/2, 280, 100, 10);
      textSize(35);
      fill(255);
      text("Continue", width/2 + 20, height/2 + 25, 280, 100);
      textSize(20);
      fill(255, 51, 51);
      text("No Gcode generation", width/2 + 20, height/2 + 60, 280, 100);
    }
    if (written && mouseX > width/2 - 300 && mouseX < width/2 - 20 && mouseY > height/2 && mouseY < height/2 + 100) {
      fill(250, 237, 100);
      stroke(10, 80);
      strokeWeight(2);
      rect(width/2 - 300, height/2, 280, 100, 10);
      textSize(35);
      fill(255);
      text("Generate Gcode", width/2 - 300, height/2 + 25, 280, 100);
      textSize(20);
      fill(255, 51, 51);
      text("Continue to 3D sketch", width/2 - 300, height/2 + 60, 280, 100);
    }
  }//end explanation

  if (draw) {
    background(0);
    //Rot.cube(100, 150, 40, MX, MY);
    textAlign(RIGHT, TOP);
    fill(255, 51, 51);
    textFont(bold);
    textSize(30);
    text("X", width - 10, 10);
    textAlign(LEFT, TOP);
    fill(200);
    textFont(regular);
    textSize(15);
    if (Gcode) {
      text("Gcode filepath: " + fileName, 10, 10);
      stroke(250, 237, 137);
      noFill();
      rect(width - 110, 50, 100, 50);
      fill(230);
      textAlign(CENTER, CENTER);
      text("Gcode Generated", width - 110, 50, 100, 50);
    } else {
      text("No Gcode generated", 10, 10);
      fill(250, 237, 137);
      rect(width - 110, 50, 100, 50);
      fill(10);
      textAlign(CENTER, CENTER);
      text("Generate Gcode", width - 110, 50, 100, 50);
    }
    if ( (mouseX > width - 40 && mouseX < width && mouseY > 0 && mouseY < 40) || (!Gcode && mouseX > width - 110 && mouseX < width - 10 && mouseY > 50 && mouseY < 100) ) {
      cursor(HAND);
    } else if (!mousePressed) {
      cursor(ARROW);
    }
    textAlign(LEFT, TOP);
    fill(153, 204, 255);
    textFont(medium);
    textSize(20);
    text("Scale: " + truncate(scale), 10, 35);
    //X,Y,Z center
    Xcen = 0;
    Ycen = 0;
    Zcen = 0;
    for (int i = 0; i < contourCurve.length; i++) {
      Xcen += contourCurve[i][0]/contourCurve.length;
      Ycen += contourCurve[i][1]/contourCurve.length;
    }
    for (int i = 0; i < 260-189+4; i++) {
      Zcen += layerHeight*DPMM;
    }
    Rot.axis(Xcen, Ycen, Zcen, MX, MY);
    //apply color to the different layers to see the different lines
    layercolor = 255;
    currentLayerDraw = 0;
    //create 4 layers as a base for the print
    for (int i = 0; i < 4; i++) {
      Rot.RotateY(contourCurve, MX);
      Rot.RotateX(rContour, MY);
      Rot.conDraw();
      currentLayerDraw = currentLayerDraw + layerHeight*DPMM;
    }
    //starting file from the 3D scan
    i = 189;
    //Loop through all the files from the 3D scan
    for (int j = 189; j < 260; j++) {
      C.load();
      //transfers SVG file into coordinates
      C.Points(lines);
      Rot.fRotateY(footCurve, MX);
      Rot.fRotateX(rFoot, MY);
      i++;
      currentLayerDraw = currentLayerDraw + layerHeight*DPMM;
      layercolor -= 2;
    }
    keyPressed();
  }//end draw
}// end void draw()

//************************************************************************
//Mouse settings to rotate and zoom with the mouse
void mousePressed() {
  if (draw) {
    lastX = mouseX;
    lastY = mouseY;
    cursor(CROSS);
  }
}
void mouseDragged() {
  if (draw) {
    MX = (savedX + (mouseX + lastX)) / 2;
    MY = (savedY + (mouseY - lastY)) / 2;
  }
}
void mouseReleased() {
  if (draw) {
    savedX = mouseX + lastX;
    savedY = mouseY - lastY;
    cursor(ARROW);
  }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scale -= e/10;
}

//***********************************************************************
//mouse clicks to go through different states
void mouseClicked() {
  if (!draw) {
    if ( written && mouseX > width/2 + 20 && mouseX < width/2 + 300 && mouseY > height/2 && mouseY < height/2 + 100) {
      explanation = false;
      draw = true;
    }
    if (written && mouseX > width/2 - 300 && mouseX < width/2 - 20 && mouseY > height/2 && mouseY < height/2 + 100) {
      written = false;
    }
  }
  if (draw) {
    if ( mouseX > width - 40 && mouseX < width && mouseY > 0 && mouseY < 40) {
      exit();
    }
    if ( !Gcode && mouseX > width - 110 && mouseX < width - 10 && mouseY > 50 && mouseY < 100) {
      i = 189;
      written = false;
      draw = false;
    }
  }
}

//*****************************************************************************
//reset function to reset the zoom
void keyPressed() {
  if (keyPressed) {
    if (key == 'r' || key == 'R') {
      scale = 1;
      translateX = 0;
      translateY = 0;
    }
    if (key == CODED) {
      if (keyCode == RIGHT) {
        translateX += 5*scale;
        Xcen += translateX;
      }
      if (keyCode == LEFT) {
        translateX -= 5*scale;
        Xcen += translateX;
      }
      if (keyCode == UP) {
        translateY -= 5*scale;
        Ycen += translateY;
      }
      if (keyCode == DOWN) {
        translateY += 5*scale;
        Ycen += translateY;
      }
    }
  }
}


//*****************************************************************************
//https://forum.processing.org/one/topic/setting-decimal-points.html
//by Nardove, limits amount of digits after the comma
float truncate (float x) {
  return round( x * 100.0f ) / 100.0f;
}