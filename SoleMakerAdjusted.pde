//Welcome to SOLEMAKER, version which saves in  file too
//(C) Loe Feijs and Troy Nachtigall at TU/e 2015           
//move mouse and click at successive interesting points  
//first make contour, then insole seed points..
//(C) Adjusted by Niek van Sleeuwen for Digital Craftsmanship 2016
//Added different size possibilities
//scaling to real sizes
//automated sole drawing, no need for approximation by clicking
//grid display over the full background
//Program first the heel and then the toe part of the insole
//Automated writing two gcode files for the heel and toe

import megamu.mesh.*;
import processing.pdf.*;

//a few utilities for generating filenames based on day and time:
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

//coding of the contour
final int MAXNRCOPOINTS = 100;
float[][] coPoints = new float[MAXNRCOPOINTS][2];
int nrCoPoints = 0;

SETUP size = new SETUP(); //To determine the shoesize
boolean gridChange = false; //to stop the background from chaning when entering shoe size;
float SIZE; // determines the shoe size
float s; //scaling factor !!!DIFFERENT FOR EACH SIZE!!!

//Start coordinates
float xc = 310;
float yc = 119.22;

final int HEEL = 8;
final int TOE = 9;
int Part = HEEL;

//The curveVertex values to draw the insole
float[] AXH = { xc + 74.75, xc + 74.75, xc + 107.34, xc + 234.44, xc + 378.17, xc + 488.52, xc + 539.8, xc + 528.97, xc + 488.96, xc + 387.34, xc + 275.47, xc + 191.04, xc + 191.04}; //HEEL
float[] AXT = { xc + 191.04, xc + 191.04, xc - 0.8, xc - 40.05, xc - 85.53, xc - 134.58, xc - 173, xc - 201.64, xc - 226.94, xc - 224.75, xc - 199.85, xc - 150.82, xc - 72.46, xc - 8.47, xc, xc + 40.05, xc + 74.75, xc + 74.75 }; //TOE

float[] AYH = { yc + 44.7, yc + 44.7, yc + 69.09, yc + 156.67, yc + 202.58, yc + 242.52, yc + 329.18, yc + 378.81, yc + 432.06, yc + 442.23, yc + 407.03, yc + 380, yc + 380 }; //HEEL
float[] AYT = { yc + 380, yc + 380, yc + 318.77, yc + 297.64, yc + 270.27, yc + 229.92, yc + 190.19, yc + 150.3, yc + 95.23, yc + 32.45, yc - 2.18, yc - 25.01, yc - 23.01, yc - 3.59, yc, yc + 20, yc + 44.7, yc + 44.7 }; //TOE

//coding of the insole
final int MAXNRINPOINTS = 1000;
float[][] inPoints = new float[MAXNRINPOINTS][2];
int nrInPoints = 0;


PImage sole, empty;
PImage grid1, grid2, grid3, grid4;
PGraphicsPDF pdf;
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
float extrusionCoefficient = .2;
int layers = 5;
int retraction = 3;

void setup() {  
  Locale.setDefault(Locale.US);//so it writes 0.1 instead of 0,1 even in Netherlands
  sole = loadImage("sole.jpg");
  empty = loadImage("empty.jpg");
  grid1 = loadImage("grid1.jpg");
  grid2 = loadImage("grid2.jpg");
  grid3 = loadImage("grid3.jpg");
  grid4 = loadImage("grid4.jpg");
  size(1196, 845);

  image(sole, 0, 0);
  println("Welcome to SOLEMAKER, version which saves gcode files   ");
  println("(C) Loe Feijs and Troy Nachtigall at TU/e 2015           ");
  println("move mouse and click at successive interesting points    ");
  println("first make contour, then insole seed points..            ");
  println("                                                         ");
  println("ENTERING CONTOUR MODE");
  print("Please enter your shoe size and press enter. Your size: ");
}

void mouseClicked() {
  if (mode == INSOLE && nrInPoints < MAXNRINPOINTS) {
    inPoints[nrInPoints  ][0] = mouseX;
    inPoints[nrInPoints++][1] = mouseY;
    ellipse(mouseX, mouseY, 3, 3);
  }
}

final int CONTOUR = 1;
final int INSOLE = 2;
int mode = CONTOUR; 
int grid = 0;
void draw() {
  if (gridChange) {
    switch (grid) {
    case 0: 
      image(sole, 0, 0);
      break;
    case 1: 
      image(grid1, 0, 0);
      image(grid1, width/2 - 28, -30);
      break;
    case 2: 
      image(grid2, 0, 0);
      image(grid2, width/2, 0);
      break;
    case 3: 
      image(grid3, 0, 0);
      image(grid3, width/2 - 2, 0);
      break;
    case 4: 
      image(grid4, 0, 0);
      image(grid4, width/2, 0);
      break;
    default: 
      image(empty, 0, 0);
      image(empty, width/2, 0);
    }       //end switch
  }
  strokeWeight(2);
  contourDraw();
  insoleDraw();
}


void contourDraw() {
  //show the contour as a set of edges
  if (nrCoPoints > 1) {
    pushMatrix();
    beginShape();
    float startX = coPoints[0][0];
    float startY = coPoints[0][1];
    curveVertex(startX, startY);
    for (int i=1; i < nrCoPoints; i++) {
      float endX   = coPoints[i][0];
      float endY   = coPoints[i][1];
      //dark green contour
      stroke(0, 128, 0);
      curveVertex(endX, endY);
      if (i == nrCoPoints - 2) {
        line(endX, endY, coPoints[0][0], coPoints[0][1]);
      }
    }
    endShape();
    popMatrix();
  }   //end if
}


void edgeWrite(float startX, float startY, float endX, float endY) {
  //auxiliary for contourWrite and insoleWrite
  //write coordinates in mm
  int L = 4;//digits before dot
  int R = 2;//digits after dot

  ext = ext + dist(startX, startY, endX, endY)*extrusionCoefficient;
  if (startX > (0.05*DPMM)) {
    txt.println("G1 X "+nf(startX / DPMM, L, R)+" Y "+nf(startY / DPMM, L, R)+" E "+nf((ext-retraction) / DPMM, L, R));
    txt.println(" G1 X "+nf(endX / DPMM, L, R)+" Y "+nf(endY / DPMM, L, R)+" E "+nf(ext / DPMM, L, R));
  }
}


void contourWrite() {
  //write the contour as a set of edges
  //essentially a variation on contourDraw
  if (nrCoPoints > 1) {
    txt.println(";CONTOUR EDGES");
    float startX = coPoints[0][0];
    float startY = coPoints[0][1];
    for (int i=1; i < nrCoPoints; i++) {
      float endX   = coPoints[i][0];
      float endY   = coPoints[i][1];
      //write the contour
      edgeWrite(startX, startY, endX, endY);
      startX = endX;
      startY = endY;
    }
    /*float endX   = coPoints[0][0];
    float endY   = coPoints[0][1];
    edgeWrite(startX, startY, endX, endY);*/
  }   //end if
}

float[][] points2edges(float[][] points, int howmany) {
  //convert from point-based representation into edges
  float[][] edges = new float[howmany + 1][4];
  float startX = points[0][0];
  float startY = points[0][1];
  for (int i = 1; i < howmany; i++) {
    float endX   = points[i][0];
    float endY   = points[i][1];
    edges[i][0] = startX;
    edges[i][1] = startY;
    edges[i][2] = endX;
    edges[i][3] = endY;
    startX = endX;
    startY = endY;
  }
  //close the loop
  edges[howmany][0] = startX;
  edges[howmany][1] = startY;
  edges[howmany][2] = points[0][0];
  edges[howmany][3] = points[0][1];
  return edges;
}


void insoleDraw() {
  Voronoi myVoronoi; 

  //show the points
  for (int i = 0; i < nrInPoints; i++) {
    float X = inPoints[i][0];
    float Y = inPoints[i][1];
    //dark red points
    stroke(255, 0, 0);
    ellipse(X, Y, 3, 3);
  }
  //copy myPoints into voPoints
  float[][] voPoints = new float[nrInPoints][2];
  for (int i = 0; i < nrInPoints; i++) {
    voPoints[i][0] = inPoints[i][0];
    voPoints[i][1] = inPoints[i][1];
  }
  myVoronoi = new Voronoi( voPoints );

  //get the edges and get rid of what is outside the contour
  float[][] myEdges = myVoronoi.getEdges();
  float[][] contour = points2edges(coPoints, nrCoPoints);
  pruneEdges(contour, myEdges);

  //show the result as a set of edges
  for (int i=0; i<myEdges.length; i++) {
    if (myEdges[i] != null) {
      float startX = myEdges[i][0];
      float startY = myEdges[i][1];
      float endX = myEdges[i][2];
      float endY = myEdges[i][3];
      //dark blue egdges
      stroke(0, 0, 128);
      ellipse(startX, startY, 3, 3);
      ellipse(endX, endY, 2, 2);
      line( startX, startY, endX, endY );
    }   //end if non null
  }    //end for
}//end insoleDraw


void insoleWrite() {
  //essentially a copy of insoleDraw, but this writes to  file
  Voronoi myVoronoi; 

  //copy myPoints into voPoints
  float[][] voPoints = new float[nrInPoints][2];
  for (int i = 0; i < nrInPoints; i++) {
    voPoints[i][0] = inPoints[i][0];
    voPoints[i][1] = inPoints[i][1];
  }
  myVoronoi = new Voronoi( voPoints );

  //get the edges and get rid of what is outside the contour
  float[][] myEdges = myVoronoi.getEdges();
  float[][] contour = points2edges(coPoints, nrCoPoints);
  pruneEdges(contour, myEdges);

  //write the result as a set of edges
  txt.println(";INSOLE EDGES");

  for (int i=0; i<myEdges.length; i++) {
    if (myEdges[i] != null) {
      float startX = myEdges[i][0];
      float startY = myEdges[i][1];
      float endX = myEdges[i][2];
      float endY = myEdges[i][3];
      edgeWrite(startX, startY, endX, endY);
    }   //end if non null
  }    //end for
}//end insoleDraw

boolean isInside(float[][] contour, float[] point) {
  //draw a line from point to a very far-away point and then test for an odd number of intersects
  float[] edge = new float[4];
  edge[0] = point[0];
  edge[1] = point[1];
  edge[2] = -1.0;
  edge[3] = -1.0;
  return (intersects(contour, edge) % 2 == 1);
}

void pruneEdges(float[][]contour, float[][] edges) {
  //shorten all edges so that they do not stick outside of the contour
  for (int i = 0; i < edges.length; i++) {
    float[] P1 = new float[2];//first point
    float[] P2 = new float[2];//second point
    P1[0] = edges[i][0];
    P1[1] = edges[i][1];
    P2[0] = edges[i][2];
    P2[1] = edges[i][3];
    if (!isInside(contour, P1) && !isInside(contour, P2)) {
      edges[i][0] = 0.1;
      edges[i][1] = 0.2;
      edges[i][2] = 0.1;
      edges[i][3] = 0.2;//exile them in some corner
    } else if (isInside(contour, P1) && isInside(contour, P2)) {
      //no pruning necessary
    } else if (!isInside(contour, P1) && isInside(contour, P2)) {
      float[] XY = intersectionpoint(contour, edges[i]);   
      edges[i][0] = XY[0];
      edges[i][1] = XY[1];
    }    //end if not inside
    else if (isInside(contour, P1) && !isInside(contour, P2)) {
      float[] XY = intersectionpoint(contour, edges[i]);   
      edges[i][2] = XY[0];
      edges[i][3] = XY[1];
    }   //end if not inside
  }    //    end for
}    //   end pruneEdges


void startGcode() {// currently for an Ultimaker 2 Extended.  Cut and Paste from Cura generated gCode
  txt.println(";FLAVOR:UltiGCode");
  txt.println("; TIME:400");
  txt.println(";MATERIAL:160");
  txt.println("; MATERIAL2: 0");
  txt.println(";NOZZLE_DIAMETER:0.400000");
  txt.println(";NOZZLE_DIAMETER2:  0.400000");
  txt.println(";Layer count: 98");
  txt.println(";LAYER: 0");
  txt.println("M107");
}

void endGcode() {// currently for an Ultimaker 2 Extended.  Cut and Paste from Cura generated gCode
  txt.println("M107");
  txt.println("G10");
  txt.println("G0 F9000 X110.000 Y126.900 Z15.000");
  txt.println("M25 ;Stop reading from this point on.");
  txt.println(";CURA_PROFILE_STRING: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");
}
void layerStart() {

  currentLayer = currentLayer + layerHeight;
  txt.println("G0  F"+nf(speed) +" Z"+nf(currentLayer));
}


void keyPressed() {
  if (gridChange) { //stops the background from changing when entering size
    if (key == '0') grid = 0;
    if (key == '1') grid = 1;
    if (key == '2') grid = 2;
    if (key == '3') grid = 3;
    if (key == '4') grid = 4;
    if (key == '5') grid = 5;
    if (key == '6') grid = 6;
    if (key == '7') grid = 7;
    if (key == '8') grid = 8;
    if (key == '9') grid = 9;
  }
  if (key == 'z' || key == ' ')
    setup();
  if (key == 'i' || key == 'I') {
    mode = INSOLE;
    println("");
    println("ENTERING INSOLE MODE");
    println("TYPE 'p' TO END AND PRINT PDF");
  }
  if (key == 't' || key == 'T') {
    size.reset();
    nrInPoints = 0;
    gridChange = false;
    Part = TOE;
    println("");
    println("ENTERING TOE MODE");
  }
  if (key == 'p'|| key == 'P') {
    // stop and print pdf
    SimpleDateFormat sdf = new SimpleDateFormat("-yyyy-MM-dd/HH-mm"); 
    Date now = new Date();
    if (Part == HEEL) {
      println("write to files SOLE"+sdf.format(now)+"_HEEL.pdf"+ " and "+"SOLE"+sdf.format(now)+"_HEEL.txt");

      pdf =  (PGraphicsPDF) beginRecord(PDF, "SOLE"+sdf.format(now) + "_HEEL.pdf");
      txt = createWriter("SOLE"+sdf.format(now) + "_HEEL.gcode");
      draw();
      stop();
      println("****HEEL PART SAVED****");
      println("ENTERING TOE MODE");
      println("PRESS 'p' AGAIN TO SAVE THE TOE PART");
      nrCoPoints = 0;
      nrInPoints = 0;
      for (int i = 0; i < AXT.length; i++) {
        coPoints[nrCoPoints  ][0] = AXT[i]*s;
        coPoints[nrCoPoints++][1] = AYT[i]*s;
      }
      Part = TOE;
    } else if (Part == TOE) {
      println("write to files SOLE"+sdf.format(now)+"_TOE.pdf"+ " and "+"SOLE"+sdf.format(now)+"_TOE.txt");

      pdf =  (PGraphicsPDF) beginRecord(PDF, "SOLE"+sdf.format(now) + "_TOE.pdf");
      txt = createWriter("SOLE"+sdf.format(now) + "_TOE.gcode");
      draw();
      stop();
      exit();
    }
  }
  if (!gridChange) { //Stops printing the digits to the console once the size is entered and accepted
    if (digit(key)) {
      size.delta(key); //determines the size
      print(key); //print for feedback to user
    }
  } 
  if (size.accept() && key == ENTER) {
    gridChange = true;
    println("");
    println("Your size: " + SIZE);
    noFill();
    println("PRESS 't' for the TOE section and 'h' for the HEEL section");
    //gives the coordinates from the curveVertex value arrays
    if (Part == HEEL) {
      println("ENTERING HEEL MODE");
      for (int i = 0; i < AXH.length; i++) {
        coPoints[nrCoPoints  ][0] = (AXH[i] - (xc + 40))*s;
        coPoints[nrCoPoints++][1] = AYH[i]*s;
      }
    }
    println("TYPE 'DELETE' TO ENTER A DIFFERENT SIZE");
    println("TYPE 'i' TO ENTER INSOLE MODE");
  } else if (key == ENTER && !size.accept()) { //if the user does something wrong or the program doesn't work
    println();
    println("Oops something went wrong. Please try again");
    size.reset();
    print("Please enter your shoe size and press enter. Your size: ");
  } else if (key == DELETE && size.accept()) { //To correct the size and try different sizes
    size.reset();
    mode = CONTOUR;
    nrCoPoints = 0;
    grid = 0;
    gridChange = false;
    print("Please enter your shoe size and press enter. Your size: ");
  }
}

void stop() {
  startGcode();
  txt.println("G0  F"+nf(speed) +" Z"+nf(layerHeight)); //Start Layer
  currentLayer = layerHeight;
  for (int i = 0; i < layers; i++) {
    insoleWrite();
    contourWrite();
    layerStart();
  }
  endGcode();
  txt.flush(); 
  txt.close(); 
  endRecord();
}
