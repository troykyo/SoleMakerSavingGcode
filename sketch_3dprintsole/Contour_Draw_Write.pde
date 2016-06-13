class contour {
  //load coordinates from X and Y Array
  void Coord(float[] CX, float[]CY) {
    //Transfer to proper array for Catmull-Rom spline, and repositioning to match the foot placement
    for (int i = 0; i < CX.length; i++) {
      coPoints[nrCoPoints  ][0] = s*(CX[i] + 260);
      coPoints[nrCoPoints++][1] = s*(CY[i] + 225);
    }
    //create Catmull-Rom spline
    Contour = new AUCurve(coPoints, 2, false);
    for (int i = 0; i < numSteps; i++) {
      float t = norm(i, 0, numSteps);
      contourCurve[i][0] = Contour.getX(t);
      contourCurve[i][1] = Contour.getY(t);
    }
    //draws the foot on the screen
    contourDraw();
  }

  void contourDraw() {
    float startX = contourCurve[0][0];
    float startY = contourCurve[0][1];
    for (int i=1; i < numSteps; i++) {
      float endX = contourCurve[i][0];
      float endY = contourCurve[i][1];
      //draw the contour
      stroke(0, 128, 0);
      line(startX, startY, endX, endY);
      startX = endX;
      startY = endY;
    }
    //generates fill lines
    float[][] contourEdge = points2edges(contourCurve, numSteps);
    //creates vertical lines
    float x = 0;
    float y1 = 0;
    float y2 = 1000;
    for (int j = 0; j < 1000/dx; j++) {
      //contains intersection points
      float[] IPoints = new float[0];
      //loop through contour edges
      for (int i = 0; i < contourEdge.length; i++) {
        //if lineLine != 0 there are intersections
        if (lineLine(contourEdge[i][0], contourEdge[i][1], contourEdge[i][2], contourEdge[i][3], x, y1, x, y2) != 0) {
          //save intersection points
          IPoints = append(IPoints, lineLine(contourEdge[i][0], contourEdge[i][1], contourEdge[i][2], contourEdge[i][3], x, y1, x, y2));
        }
      }
      //draws intersection points on the screen
      IPoints = sort(IPoints);
      if (IPoints.length > 1) {
        stroke(255, 0, 0);
        line(x, IPoints[0], x, IPoints[1]);
      }
      x = x + dx;
    }
  }
//the same as contourDraw, but generates Gcode instead of drawing on the screen
  void contourWrite() {
    txt.println(";CONTOUR EDGES");
    float startX = contourCurve[0][0];
    float startY = contourCurve[0][1];
    for (int i=1; i < numSteps; i++) {
      float endX = contourCurve[i][0];
      float endY = contourCurve[i][1];
      edgeWrite(startX, startY, endX, endY);
      startX = endX;
      startY = endY;
    }
    txt.println(";CONTOUR FILL");
    float[][] contourEdge = points2edges(contourCurve, numSteps);
    float x = 0;
    float y1 = 0;
    float y2 = 1000;
    for (int j = 0; j < 1000/dx; j++) {
      float[] IPoints = new float[0];
      for (int i = 0; i < contourEdge.length; i++) {
        if (lineLine(contourEdge[i][0], contourEdge[i][1], contourEdge[i][2], contourEdge[i][3], x, y1, x, y2) != 0) {
          IPoints = append(IPoints, lineLine(contourEdge[i][0], contourEdge[i][1], contourEdge[i][2], contourEdge[i][3], x, y1, x, y2));
        }
      }
      IPoints = sort(IPoints);
      if (IPoints.length > 1) {
        edgeWrite(x, IPoints[0], x, IPoints[1]);
      }
      x = x + dx;
    }
  }
}
 //transfers coordinates into mm for 3D printing 
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