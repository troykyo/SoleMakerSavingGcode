int n1 = 10;
int n2 = 8;
int n3 = 4;
int n4 = 6;
int n5 = 3;
int n6 = 7;
int steps = 500;
int raarar = 0;

Car[][] myCar = new Car[n1][n2];
Car[][] bestCar = new Car[n3][n4];
Car[][] rageCar = new Car[n5][n6];
//Points[][][] curvePoints = new Points[2][steps+2][steps+2];

//Create Multiple tiny objects!
//Create one big object!
//Used the collision detecter to determine if the Big one hits the smaller ones... If so, It will destroy the smaller ones.

void setup(){
  size(960,960);
  smooth();
  for(int i=0;i<n1;i++){
    for(int o=0;o<n2;o++){            //i for number of objects in row; o for number of rows
    
        float dphi = random(2*PI);
        float dx = cos(dphi);
        float dy = sin(dphi);
//      myCar[i][o] = new Car(300+i*30, 300+i*30 + o*30, 20, 20,255, dx, dy, true);
      myCar[i][o] = new Car(130 + random(670), 130 + random(670), 10, 10,255, dx, dy, true, dphi, false, false, true);
    }
  }
  for(int i=0;i<n3;i++){
    for(int o=0;o<n4;o++){
      
        float dphi = random(2*PI);
        float dx = cos(dphi);
        float dy = sin(dphi);
//      bestCar[i][o] = new Car(width/2,height/2,40,40,color(255,0,0), dx, dy, true);
      bestCar[i][o] = new Car(130 + random(670), 130 + random(670),18,18,color(255,0,0), dx, dy, true, dphi, false, false, false);
  //Create Cars(x,y,width,height,color,speed in x direction, speed in y direction, visible(yes/no));
    }
  }
  
  for(int i=0;i<n5;i++){
    for(int o=0;o<n6;o++){            //i for number of objects in row; o for number of rows
    
        float dphi = random(2*PI);
        float dx = cos(dphi);
        float dy = sin(dphi);
//      rageCar[i][o] = new Car(300+i*30, 300+i*30 + o*30, 30, 30,255, dx, dy, true);
      rageCar[i][o] = new Car(130 + random(670), 130 + random(670), 15, 15,color(0,0,255), dx, dy, true, dphi, false, false, false);
    }
  }
  
}

//void ellipse(float xc, float yc, int in){
//     //xc,yc coordinates of centre
//     float a = 20; //half-diameter horizontally
//     float b = 100; //half-diameter vertically
//     float dphi = 2*PI/steps;
//     int index = in;
//     noFill();
//     beginShape();
//     curveVertex(xc + a, yc);
//     
//     for (int i=0; i<steps + 1; i++){
//          float x = xc + a * cos(i * dphi);
//          float y = yc + b * sin(i * dphi);
//          curveVertex(x,y);
//          curvePoints[index][i][i] = new Points(x,y);
//     }
//     endShape();
//}

void draw(){
//  background(color(200,200,200)); // for fun, comment this background statement out ;) and then run the program
  stroke(0);
  line(800,100,800,800);
  line(100,100,100,800);
  line(100,800,800,800);
  line(100,100,800,100);
//  ellipse(200, height/2, 0);
//  ellipse(500, height/2, 1);

//  for(int i=0;i<n1;i++){
//    for(int o=0;o<n2;o++){
//            myCar[i][o].display();
////            myCar[i][o].move();
////            myCar[i][o].detectCol(myCar[i][o]);        //detect for each object if it hits the big one
////            myCar[i][o].changeAngle();
//    }
//  }
  for(int j=0;j<n3;j++){
        for(int k=0;k<n4;k++){  
          if((bestCar[j][k].getScale() == false) && (bestCar[j][k].getDone() == false) && (j == 0) && (k == 0)){
                 bestCar[j][k].setScale(true);
                 bestCar[j][k].setColt(true);
          } if((bestCar[j][k].getDone() == true) && (j < n3-1) && (k < n4)){
                bestCar[j+1][k].setScale(true);
                bestCar[j+1][k].setColt(true);
          } else if((bestCar[j][k].getDone() == true) && (j == n3-1) && (k < n4-1)){
                bestCar[0][k+1].setScale(true);
                bestCar[0][k+1].setColt(true);
          }
          if((bestCar[j][k].getScale() == true) && (bestCar[j][k].getDone() == false)){
                bestCar[j][k].scaleSize();
    //            bestCar[j][k].move();
                bestCar[j][k].detectCol(bestCar[j][k]);
    //            bestCar[j][k].changeAngle();
//                      for(int n=0;n<n5;n++){
//                        for(int m=0;m<n6;m++){
//                          if(rageCar[n][m].getColt() == true){
//                              bestCar[j][k].detectColCars(bestCar[j][k],rageCar[n][m]);
//                          }
//                        }
//                      }
          
                      for(int n=0;n<n3;n++){
                        for(int m=0;m<n4;m++){                              
                          if((bestCar[n][m].getColt() == true) && (bestCar[j][k] != bestCar[n][m])){
                            
                              bestCar[j][k].detectSelf(bestCar[j][k],bestCar[n][m]);      
                              
                          }
                        }                              
                      }
          
                bestCar[j][k].display();            
        }
        }
  }
//  for(int n=0;n<n5;n++){
//    for(int m=0;m<n6;m++){
//          if((rageCar[n][m].getScale() == false) && (rageCar[n][m].getDone() == false) && (n == 0) && (m == 0)){
//            rageCar[n][m].setScale(true);
//            rageCar[n][m].setColt(true);
//          } if((rageCar[n][m].getDone() == true) && (n < n5-1) && (m < n6)){
//            rageCar[n+1][m].setScale(true);
//            rageCar[n+1][m].setColt(true);
//          } else if((rageCar[n][m].getDone() == true) && (n == n5-1) && (m < n6-1)){
//            rageCar[0][m+1].setScale(true);
//            rageCar[0][m+1].setColt(true);
//          }
//          if((rageCar[n][m].getScale() == true) && (rageCar[n][m].getDone() == false)){
//          
//            rageCar[n][m].scaleSize();
////            rageCar[n][m].move();
//            rageCar[n][m].detectCol(rageCar[n][m]);
////            rageCar[n][m].changeAngle();
//                  for(int j=0;j<n3;j++){
//                    for(int k=0;k<n4;k++){
//                      if(bestCar[j][k].getColt() == true){
//                          rageCar[n][m].detectColCars(rageCar[n][m],bestCar[j][k]);
//                      }
//                    }
//                  }
//                  for(int j=0;j<n1;j++){
//                    for(int k=0;k<n2;k++){
//                      if(myCar[j][k].getColt() == true){
//                        rageCar[n][m].detectColCars(rageCar[n][m],myCar[j][k]);
//                      }
//                    }
//                  }
//            rageCar[n][m].display();  
//          }
//    }
//  }
}

