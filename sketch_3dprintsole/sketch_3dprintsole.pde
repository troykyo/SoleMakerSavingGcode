/* ©Niek van Sleeuwen TU/e 2016
 For the elective Digital Craftsmanship
 Creates Gcode file for the Ultimaker 2 from a series of SVG files with polygon coordinates. 
 SVG files are extracted from a STL file, every SVG is a 0.4mm layer.
 *********************************************************************************************
 Collisiondetection combined with:
 LINE/LINE COLLISION FUNCTION
 Jeff Thompson // v0.9 // November 2011 // www.jeffreythompson.org
 *********************************************************************************************
 points2edges and Gcode 'generator' written by Loe Feijs;
 *********************************************************************************************
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


String line[];
String lines[];
String chars[];
String path;
String coords[];
String split[];
String append[];
float coord[][];
String fileName;

float s = 0.5; //scale factor for testprinting;
int dx = 5; //per dx pixels a line is drawn to fill the insole.

int i = 189; // start layer 3Dscan
int numSteps = 300; //Number of points to generate the shape (accuracy). 

float footCurve[][] = new float[numSteps][2]; //coordinates 3D scan/SVG file foot
float contourCurve[][] = new float[numSteps][2]; //coordinates contour, as from oneday.shoe (SoleSize 42.5);


float[] X = {0, 0, 167.847, 208.772, 258.33, 320.67, 375.525, 424.576, 483.466, 531.339, 543.054, 530.414, 480.353, 425.422, 382.479, 335.927, 296.062, 149.037, 23.86, -75.922, -175.706, -207.915, -224.852, -169.783, -72.775, 0, 0};
float[] Y = {0, 0, -112.477, -130.146, -148.676, -162.444, -167.7757, -165.417, -151.146, -110.48, -69.466, -16.689, 43.368, 81.507, 102.285, 116.819, 127.903, 172.591, 256.837, 318.601, 305.057, 265.767, 201.351, 115.745, 49.446, 0, 0};
 
//translate contour to Catmull-Rom spline
float[][] coPoints = new float[X.length][2];
int nrCoPoints = 0;


PrintWriter txt;

import java.util.Locale;
float DPMM = 2.834646;//dots per mm
//processing has 72 DPI, one inch is 25.4 mm
//so we have 2,834645669 dots per mm  

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
  size(1000, 1000);
  //frameRate(10);
  //Draws the contour with filling lines
  Con.Coord(X, Y);
  SimpleDateFormat sdf = new SimpleDateFormat("-yyyy-MM-dd/HH-mm"); 
  Date now = new Date();
  fileName = "SOLE_TROY"+sdf.format(now) + "_ACC_"+ numSteps + "_DX_" + dx + "_SCALE_"+ s + ".gcode";
  txt = createWriter(fileName);
  startGcode();
  txt.println("G0  F"+nf(speed) +" Z"+nf(layerHeight)); //Start Layer
  currentLayer = layerHeight;
  //create baselayer of the insole in Gcode
  for (int i = 0; i < 4; i++) {
    Con.contourWrite();
    layerStart();
  }
}

void draw() {
  //Loads one svg file at a time
  C.load();
  //transfers SVG file into coordinates
  C.Points(lines);
  noFill();
  strokeWeight(0.1);
  stroke(0);
  //draws the foot lines
  C.sketch();
  //draws the fill lines, between foot and contour(insole boundaries) lines
  Col.Fill(contourCurve, footCurve);
  //writes the fill lines to Gcode
  Col.FillWrite(contourCurve, footCurve);
  layerStart();
  //for this scan the layer names go up to "Artboard 1_layer263-01.svg"
  //When the final file is reached save the file and close the program
  if (i == 263) {
    endGcode();
    txt.flush(); 
    txt.close();
    println("File saved as: " + fileName);
    exit();
  }
}