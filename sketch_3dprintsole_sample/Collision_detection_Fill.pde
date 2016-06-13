class collision {

  void Fill(float[][] contour, float[][] foot) {
    float[][] contourEdge = points2edges(contour, numSteps);
    float[][] footEdge = points2edges(foot, numSteps);
    //creates vertical lines
    float x = 0;
    float y1 = 0;
    float y2 = 1000;
    //number of lines
    for (int j = 0; j < 1000/dx; j++) {
      //contains intersection points
      float[] IPoints = new float[0];
      //loop through all contour edges
      for (int i = 0; i < contourEdge.length; i++) {
        //if lineLine != 0 there are intersections
        if (lineLine(contourEdge[i][0], contourEdge[i][1], contourEdge[i][2], contourEdge[i][3], x, y1, x, y2) != 0) {
          //Save intersection points
          IPoints = append(IPoints, lineLine(contourEdge[i][0], contourEdge[i][1], contourEdge[i][2], contourEdge[i][3], x, y1, x, y2));
        }
      }
      //if the line is inside the contour check for intersects with the foot
      if (IPoints.length == 2) {
        //loop through all footoutline  edges
        for (int i = 0; i < footEdge.length; i++) {
          //if lineLine != 0 there are intersections
          if (lineLine(footEdge[i][0], footEdge[i][1], footEdge[i][2], footEdge[i][3], x, IPoints[0], x, IPoints[1]) != 0) {
            //Save intersection points
            IPoints = append(IPoints, lineLine(footEdge[i][0], footEdge[i][1], footEdge[i][2], footEdge[i][3], x, IPoints[0], x, IPoints[1]));
          }
        }
      }
      stroke(255, 0, 0);
      IPoints = sort(IPoints);
      //only if the line is inside the contour draw it
      if (IPoints.length > 1) {
        //Bunch of optimalizations to make sure the line isn't drawn in the foot shape, but between the shape and the contour
        if (IPoints.length > 7) {
          line(x, IPoints[0], x, IPoints[1]);
          line(x, IPoints[2], x, IPoints[3]);
          line(x, IPoints[4], x, IPoints[5]);
          line(x, IPoints[6], x, IPoints[7]);
        } else if ( IPoints.length > 5) {
          line(x, IPoints[0], x, IPoints[1]);
          line(x, IPoints[2], x, IPoints[3]);
          line(x, IPoints[4], x, IPoints[5]);
        } else if (IPoints.length > 3) {
          line(x, IPoints[0], x, IPoints[1]);
          line(x, IPoints[2], x, IPoints[3]);
        } else if (IPoints.length > 1) {
          line(x, IPoints[0], x, IPoints[1]);
        }
      }
      x = x + dx;
    }
  } // end void

//Same as Fill, but generates the Gcode coordinates instead of drawing on the screen
  void FillWrite(float[][] contour, float[][] foot) {
     txt.println(";INSOLE FILL");
    float[][] contourEdge = points2edges(contour, numSteps);
    float[][] footEdge = points2edges(foot, numSteps);
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
      if (IPoints.length == 2) {
        for (int i = 0; i < footEdge.length; i++) {
          if (lineLine(footEdge[i][0], footEdge[i][1], footEdge[i][2], footEdge[i][3], x, IPoints[0], x, IPoints[1]) != 0) {
            IPoints = append(IPoints, lineLine(footEdge[i][0], footEdge[i][1], footEdge[i][2], footEdge[i][3], x, IPoints[0], x, IPoints[1]));
          }
        }
      }
      IPoints = sort(IPoints);
      if (IPoints.length > 1 && IPoints[0] > 0 && IPoints[1] > 0 && x < Xwidth && x > Xmin) {
        if (IPoints.length > 7) {
          edgeWrite(x, IPoints[0], x, IPoints[1]);
          edgeWrite(x, IPoints[2], x, IPoints[3]);
          edgeWrite(x, IPoints[4], x, IPoints[5]);
          edgeWrite(x, IPoints[6], x, IPoints[7]);
        } else if ( IPoints.length > 5) {
          edgeWrite(x, IPoints[0], x, IPoints[1]);
          edgeWrite(x, IPoints[2], x, IPoints[3]);
          edgeWrite(x, IPoints[4], x, IPoints[5]);
        } else if (IPoints.length > 3) {
          edgeWrite(x, IPoints[0], x, IPoints[1]);
          edgeWrite(x, IPoints[2], x, IPoints[3]);
        } else if (IPoints.length > 1) {
          edgeWrite(x, IPoints[0], x, IPoints[1]);
        }
      }
      x = x + dx;
    }
  } // end void
}// end class

//Credits to Loe Feijs for writing points2edges
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


/*LINE/LINE COLLISION FUNCTION
 Jeff Thompson // v0.9 // November 2011 // www.jeffreythompson.org
 
 Based on the tutorial by Paul Bourke (thanks!):
 http://paulbourke.net/geometry/lineline2d
 ... and Ibackstrom (thanks!)
 http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=geometry2*/
float lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // find uA and uB
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // note: if the below equations is true, the lines are parallel
  // ... this is the denominator of the above equations
  // (y4-y3)*(x2-x1) - (x4-x3)*(y2-y1)

  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

    // find intersection point, if desired
    //float intersectionX = x1 + (uA * (x2-x1));
    float intersectionY = y1 + (uA * (y2-y1));
    noStroke();
    fill(0, 0, 255);
    //ellipse(intersectionX, intersectionY, 2, 2);


    return intersectionY;
  } else return 0;
}