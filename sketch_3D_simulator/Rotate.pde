class rotation {


  void RotateY(float[][] contour, float theta) {
    //direction vector
    int u = 0;
    int v = 1;
    int w = 0;
    rContour = new float[contour.length][3];
    for (int j = 0; j < contour.length; j++) {
      rContour[j] = Rotate(contour[j][0], contour[j][1], currentLayerDraw, theta, u, v, w, Xcen, Ycen, Zcen);
    }
  }
  void RotateX(float[][] contour, float theta) {
    //direction vector
    int u = 1;
    int v = 0;
    int w = 0;
    rContour2 = new float[contour.length][3];
    for (int i = 0; i < contour.length; i++) {
      rContour2[i] = Rotate(contour[i][0], contour[i][1], currentLayerDraw, theta, u, v, w, Xcen, Ycen, Zcen);
    }
    //************contour filling**********************
    float[][] contourEdge = points2edges(contour, numSteps);
    //creates vertical lines
    float x = 0;
    float y1 = 0;
    float y2 = 1000;
    for (int j = 0; j < 1500/dx; j++) {
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
        rContourFill = new float[IPoints.length][3];
        for (int i = 0; i < IPoints.length; i++) {
          rContourFill[i] = Rotate(x, IPoints[i], currentLayerDraw, theta, u, v, w, Xcen, Ycen, Zcen);
        }
        stroke(255);
        line(rContourFill[0][0] + translateX, rContourFill[0][1] + translateY, rContourFill[0][2]*scale, rContourFill[1][0] + translateX, rContourFill[1][1] + translateY, rContourFill[1][2]*scale);
      }
      x = x + dx;
    }
  }

  void conDraw() {
    stroke(255);
    strokeWeight(1);
    float startX = rContour2[0][0];
    float startY = rContour2[0][1];
    float startZ = rContour2[0][2];
    for (int j = 1; j < rContour.length; j++) {
      float endX = rContour2[j][0];
      float endY = rContour2[j][1];
      float endZ = rContour2[j][2];
      line(startX + translateX, startY + translateY, startZ*scale, endX + translateX, endY + translateY, endZ*scale);
      startX = endX;
      startY = endY;
      startZ = endZ;
    }
  }

  void fRotateY(float[][] foot, float theta) {
    //direction vector
    int u = 0;
    int v = 1;
    int w = 0;
    rFoot = new float[foot.length][3];
    for (int i = 0; i < foot.length; i++) {
      rFoot[i] = Rotate(foot[i][0], foot[i][1], currentLayerDraw, theta, u, v, w, Xcen, Ycen, Zcen);
    }
  }

  void fRotateX(float[][] foot, float theta) {
    //direction vector
    int u = 1;
    int v = 0;
    int w = 0;
    rFoot = new float[foot.length][3];
    for (int i = 0; i < foot.length; i++) {
      rFoot[i] = Rotate(foot[i][0], foot[i][1], currentLayerDraw, theta, u, v, w, Xcen, Ycen, Zcen);
    }
    float[][] contourEdge = points2edges(rContour, numSteps);
    float[][] footEdge = points2edges(foot, numSteps);
    //creates vertical lines
    float x = 0;
    float y1 = 0;
    float y2 = 1000;
    //number of lines
    for (int j = 0; j < 1500/dx; j++) {
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
      strokeWeight(1);
      stroke(layercolor);
      IPoints = sort(IPoints);
      //only if the line is inside the contour draw it
      if (IPoints.length > 1) {
        rFootFill = new float[IPoints.length][3];
        for (int i = 0; i < IPoints.length; i++) {
          rFootFill[i] = Rotate(x, IPoints[i], currentLayerDraw, theta, u, v, w, Xcen, Ycen, Zcen);
        }
        //Bunch of optimalizations to make sure the line isn't drawn in the foot shape, but between the shape and the contour
        if (IPoints.length > 7) {
          line(rFootFill[0][0] + translateX, rFootFill[0][1] + translateY, rFootFill[0][2]*scale, rFootFill[1][0] + translateX, rFootFill[1][1] + translateY, rFootFill[1][2]*scale);
          line(rFootFill[2][0] + translateX, rFootFill[2][1] + translateY, rFootFill[2][2]*scale, rFootFill[3][0] + translateX, rFootFill[3][1] + translateY, rFootFill[3][2]*scale);
          line(rFootFill[4][0] + translateX, rFootFill[4][1] + translateY, rFootFill[4][2]*scale, rFootFill[5][0] + translateX, rFootFill[5][1] + translateY, rFootFill[5][2]*scale);
          line(rFootFill[6][0] + translateX, rFootFill[6][1] + translateY, rFootFill[6][2]*scale, rFootFill[7][0] + translateX, rFootFill[7][1] + translateY, rFootFill[7][2]*scale);
        } else if ( IPoints.length > 5) {
          line(rFootFill[0][0] + translateX, rFootFill[0][1] + translateY, rFootFill[0][2]*scale, rFootFill[1][0] + translateX, rFootFill[1][1] + translateY, rFootFill[1][2]*scale);
          line(rFootFill[2][0] + translateX, rFootFill[2][1] + translateY, rFootFill[2][2]*scale, rFootFill[3][0] + translateX, rFootFill[3][1] + translateY, rFootFill[3][2]*scale);
          line(rFootFill[4][0] + translateX, rFootFill[4][1] + translateY, rFootFill[4][2]*scale, rFootFill[5][0] + translateX, rFootFill[5][1] + translateY, rFootFill[5][2]*scale);
        } else if (IPoints.length > 3) {
          line(rFootFill[0][0] + translateX, rFootFill[0][1] + translateY, rFootFill[0][2]*scale, rFootFill[1][0] + translateX, rFootFill[1][1] + translateY, rFootFill[1][2]*scale);
          line(rFootFill[2][0] + translateX, rFootFill[2][1] + translateY, rFootFill[2][2]*scale, rFootFill[3][0] + translateX, rFootFill[3][1] + translateY, rFootFill[3][2]*scale);
        } else if (IPoints.length > 1) {
          line(rFootFill[0][0] + translateX, rFootFill[0][1] + translateY, rFootFill[0][2]*scale, rFootFill[1][0] + translateX, rFootFill[1][1] + translateY, rFootFill[1][2]*scale);
        }
      }
      x = x + dx;
    }
  } 

  void cube(float X, float Y, float depth, float thetaX, float thetaY) {
    stroke(255);
    strokeWeight(5);
    fill(200);
    cube = createShape();
    cube.beginShape(QUADS);
    //texture(foto);
    // +Z "front" face
    cube.vertex(-1*depth, -1*depth, 1*depth);
    cube.vertex( 1*depth, -1*depth, 1*depth);
    cube.vertex( 1*depth, 1*depth, 1*depth);
    cube.vertex(-1*depth, 1*depth, 1*depth);
    // -Z "back" face
    cube.vertex( 1*depth, -1*depth, -1*depth);
    cube.vertex(-1*depth, -1*depth, -1*depth);
    cube.vertex(-1*depth, 1*depth, -1*depth);
    cube.vertex( 1*depth, 1*depth, -1*depth);
    // +Y "bottom" face
    cube.vertex(-1*depth, 1*depth, 1*depth);
    cube.vertex( 1*depth, 1*depth, 1*depth);
    cube.vertex( 1*depth, 1*depth, -1*depth);
    cube.vertex(-1*depth, 1*depth, -1*depth);
    // -Y "top" face
    cube.vertex(-1*depth, -1*depth, -1*depth);
    cube.vertex( 1*depth, -1*depth, -1*depth);
    cube.vertex( 1*depth, -1*depth, 1*depth);
    cube.vertex(-1*depth, -1*depth, 1*depth);
    // +X "right" face
    cube.vertex( 1*depth, -1*depth, 1*depth);
    cube.vertex( 1*depth, -1*depth, -1*depth);
    cube.vertex( 1*depth, 1*depth, -1*depth);
    cube.vertex( 1*depth, 1*depth, 1*depth);
    // -X "left" face
    cube.vertex(-1*depth, -1*depth, -1*depth);
    cube.vertex(-1*depth, -1*depth, 1*depth);
    cube.vertex(-1*depth, 1*depth, 1*depth);
    cube.vertex(-1*depth, 1*depth, -1*depth);
    cube.endShape();
    Xcen = 0;
    Ycen = 0;
    Zcen = 0;
    int u = 0;
    int v = 1;
    int w = 0;
    for (int i = 0; i < cube.getVertexCount(); i++) {
      float[] rotatePoints = new float[3];
      PVector vec = cube.getVertex(i);
      rotatePoints = Rotate(vec.x, vec.y, vec.z, thetaX, u, v, w, Xcen, Ycen, Zcen);
      vec.x = rotatePoints[0];
      vec.y = rotatePoints[1];
      vec.z = rotatePoints[2];
      cube.setVertex(i, vec);
    }
    u = 1;
    v = 0;
    w = 0;
    for (int i = 0; i < cube.getVertexCount(); i++) {
      float[] rotatePoints = new float[3];
      PVector vec = cube.getVertex(i);
      rotatePoints = Rotate(vec.x, vec.y, vec.z, thetaY, u, v, w, Xcen, Ycen, Zcen);
      vec.x = rotatePoints[0] + X;
      vec.y = rotatePoints[1] + Y;
      vec.z = rotatePoints[2];
      cube.setVertex(i, vec);
    }
    shape(cube);
  }

  void axis(float X, float Y, float Z, float thetaX, float thetaY) {
    int u = 0;
    int v = 1;
    int w = 0;
    float[] rotatePoints = new float[3];
    strokeWeight(1);
    stroke(255, 0, 0);
    rotatePoints = Rotate(2000, Y, Z, thetaX, u, v, w, X, Y, Z);
    u = 1;
    v = 0;
    w = 0;
    rotatePoints = Rotate(rotatePoints[0], rotatePoints[1], rotatePoints[2], thetaY, u, v, w, X, Y, Z);
    line(X + translateX, Y + translateY, Z*scale, rotatePoints[0] + translateX, rotatePoints[1] + translateY, rotatePoints[2]*scale);
    stroke(0, 255, 0);
    u = 0;
    v = 1;
    w = 0;
    rotatePoints = Rotate(X, 2000, Z, thetaX, u, v, w, X, Y, Z);
    u = 1;
    v = 0;
    w = 0;
    rotatePoints = Rotate(rotatePoints[0], rotatePoints[1], rotatePoints[2], thetaY, u, v, w, X, Y, Z);
    line(X + translateX, Y + translateY, Z*scale, rotatePoints[0] + translateX, rotatePoints[1] + translateY, rotatePoints[2]*scale);
    stroke(0, 0, 255);
    u = 0;
    v = 1;
    w = 0;
    rotatePoints = Rotate(X, Y, 2000, thetaX, u, v, w, X, Y, Z);
    u = 1;
    v = 0;
    w = 0;
    rotatePoints = Rotate(rotatePoints[0], rotatePoints[1], rotatePoints[2], thetaY, u, v, w, X, Y, Z);
    line(X + translateX, Y + translateY, Z*scale, rotatePoints[0] + translateX, rotatePoints[1] + translateY, rotatePoints[2]*scale);
  }
  /*************************************************************************************
   own implementation of the formula from Glenn Murray, found at: https://sites.google.com/site/glennmurray/Home/rotation-matrices-and-formulas/rotation-about-an-arbitrary-axis-in-3-dimensions
   */
  float[] Rotate(float X, float Y, float Z, float theta, int u, int v, int w, float a, float b, float c) {
    float[] rotatePoints = new float [3];
    theta = (theta*PI)/180;
    rotatePoints[0] = (a*(sq(v)+sq(w))-u*(b*v + c*w - u*X - v*Y - w*Z))*(1-cos(theta)) + X*cos(theta) + (-c*v + b*w - w*Y + v*Z)*sin(theta);
    rotatePoints[1] = (b*(sq(u)+sq(w))-v*(a*u + c*w - u*X - v*Y - w*Z))*(1-cos(theta)) + Y*cos(theta) + (c*u - a*w + w*X - u*Z)*sin(theta);
    rotatePoints[2] = (c*(sq(u)+sq(v))-w*(a*u + b*v - u*X - v*Y - w*Z))*(1-cos(theta)) + Z*cos(theta) + (-b*v + a*v - v*X + u*Y)*sin(theta);

    return rotatePoints;
  }
}