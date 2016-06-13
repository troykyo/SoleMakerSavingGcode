class PtoC {
  void load() {
    lines = loadStrings("Artboard 1_layer" + i + "-01.svg");
  }
  void Points(String lines[]) {
    line = new String [0];
    //The SVG files produced through an Illustrator script, 
    //by Tom Byrne, from http://www.tbyrne.org/export-illustrator-layers-to-svg-files
    //produce a file where coordinates start on line 6
    for (int i = 6; i < lines.length - 4; i++) {
      line = append(line, lines[i]);
    }
    //Bunch of code to remove characters and leave the digits(coordinates)
    //and split the X,Y coordinates to process further
    path = join(line, "");
    chars = split(path, '"');
    if (chars.length > 9) {
      coords = concat(split(trim(chars[5]), " "), split(trim(chars[11]), " "));
    } else {
      coords = split(trim(chars[5]), " ");
    }
    coord = new float[coords.length][2];
    int r = 0;
    for (String row : coords) {
      coord[r++] = float(split(trim(row), ','));
    }
    for (int i = 0; i < coord.length; i++) {
      coord[i][0] = s*(coord[i][0] - 30 - Xmin);
      coord[i][1] = s*(coord[i][1] - 45);
    }
    //create Catmull-Rom spline from SVG coordinates
    MyCurve = new AUCurve(coord, 2, true);
    for (int i = 0; i < numSteps; i++) {
      float t = norm(i, 0, numSteps);
        footCurve[i][0] = MyCurve.getX(t);
        footCurve[i][1] = MyCurve.getY(t);
    }
  }

  //Draw the footoutlines on the screen.
  void sketch() {
    beginShape();
    float startX = footCurve[0][0];
    float startY = footCurve[0][1];
    for (int i=1; i < numSteps; i++) {
      float endX = footCurve[i][0];           // get X at this t
      float endY = footCurve[i][1];           // get Y at this t
      //write the contour
      line(startX, startY, endX, endY);
      startX = endX;
      startY = endY;
    }
    endShape();
    i++;
    //******************263 final layer so stop looking for other files *********************
    if (i >= 263) {
      i = 263;
    }
  }
}