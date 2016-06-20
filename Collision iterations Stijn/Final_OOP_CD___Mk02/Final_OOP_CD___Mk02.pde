int n1 = 10;
int n2 = 20;
int n3 = 10;
int n4 = 20;
int n5 = 10;
int n6 = 20;
int steps = 500;
int raarar = 0;
int numbEll = 50;

Car[][] myCar = new Car[n1][n2];
Car[][] bestCar = new Car[n3][n4];
Car[][] rageCar = new Car[n5][n6];
Points[][][] curvePoints = new Points[numbEll][steps+2][steps+2];

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
      myCar[i][o] = new Car(130 + random(670), 130 + random(670), 0, 0,255, dx, dy, true, dphi, false, false, true);
    }
  }
  for(int i=0;i<n3;i++){
    for(int o=0;o<n4;o++){
      
        float dphi = random(2*PI);
        float dx = cos(dphi);
        float dy = sin(dphi);
//      bestCar[i][o] = new Car(width/2,height/2,40,40,color(255,0,0), dx, dy, true);
      bestCar[i][o] = new Car(130 + random(670), 130 + random(670),0,0,color(255,0,0), dx, dy, true, dphi, false, false, false);
  //Create Cars(x,y,width,height,color,speed in x direction, speed in y direction, visible(yes/no));
    }
  }
  
  for(int i=0;i<n5;i++){
    for(int o=0;o<n6;o++){            //i for number of objects in row; o for number of rows
    
        float dphi = random(2*PI);
        float dx = cos(dphi);
        float dy = sin(dphi);
//      rageCar[i][o] = new Car(300+i*30, 300+i*30 + o*30, 30, 30,255, dx, dy, true);
      rageCar[i][o] = new Car(130 + random(670), 130 + random(670),0, 0,color(0,0,255), dx, dy, true, dphi, false, false, false);
    }
  }
}

void ellipse(float xc, float yc, int in){
     //xc,yc coordinates of centre
     float a = 20; //half-diameter horizontally
     float b = 100; //half-diameter vertically
     float dphi = 2*PI/steps;
     int index = in;
     noFill();
     beginShape();
     curveVertex(xc + a, yc);
     
     for (int i=0; i<steps + 1; i++){
          float x = xc + a * cos(i * dphi);
          float y = yc + b * sin(i * dphi);
          curveVertex(x,y);
          curvePoints[index][i][i] = new Points(x,y);
     }
     endShape();
}

void draw(){
//  background(color(200,200,200)); // for fun, comment this background statement out ;) and then run the program
  stroke(0);
  line(800,100,800,800);
  line(100,100,100,800);
  line(100,800,800,800);
  line(100,100,800,100);
  
  for(int i=0; i < numbEll;i++){
    int dx = 5*i;
    float dy = 20*sin(radians(dx));
    ellipse(200 + dx, height/2+dy, i);
  }


//
//  for(int i=0;i<n1;i++){
//        for(int o=0;o<n2;o++){  
//          if((myCar[i][o].getScale() == false) && (myCar[i][o].getDone() == false) && (i == 0) && (o == 0)){
//                 myCar[i][o].setScale(true);
//                 myCar[i][o].setColt(true);
//          } if((myCar[i][o].getDone() == true) && (i < n1-1) && (o < n2)){
//                myCar[i+1][o].setScale(true);
//                myCar[i+1][o].setColt(true);
//          } else if((myCar[i][o].getDone() == true) && (i == n1-1) && (o < n2-1)){
//                myCar[0][o+1].setScale(true);
//                myCar[0][o+1].setColt(true);
//          }
//          if((myCar[i][o].getScale() == true) && (myCar[i][o].getDone() == false)){
//            
////                  myCar[i][o].move();
////                  myCar[i][o].changeAngle();
//                  myCar[i][o].detectCol(myCar[i][o]);
//                
//                      
//                    for(int m =0;m<numbEll;m++){
//                      for(int n=0;n< steps+1;n++){  
//                              myCar[i][o].detectColCur(myCar[i][o],curvePoints[m][n][n]);                                                 
//                      }
//                    }
//                    for(int n=0;n<n1;n++){
//                        for(int m=0;m<n2;m++){                              
//                          if((myCar[n][m].getColt() == true) && (myCar[i][o] != myCar[n][m])){
//                            
//                              myCar[i][o].detectSelf(myCar[i][o],myCar[n][m]);      
//                              
//                          }
//                        }                              
//                      }
//                    
//                    for(int n=0;n<n3;n++){
//                        for(int m=0;m<n4;m++){                              
//                          if(bestCar[n][m].getColt() == true){
//                            
//                              myCar[i][o].detectColCars(myCar[i][o],bestCar[n][m]);      
//                              
//                          }
//                        }                              
//                      }
//                    for(int n=0;n<n5;n++){
//                        for(int m=0;m<n6;m++){                              
//                          if(rageCar[n][m].getColt() == true){
//                            
//                              myCar[i][o].detectColCars(myCar[i][o],rageCar[n][m]);      
//                              
//                          }
//                        }                              
//                      }
//                myCar[i][o].display();    
//                if(myCar[i][o].getDone() == false){
//                  myCar[i][o].scaleSize();
//                }
//                        
//        }
//        }
//   }
//

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
            
//                  bestCar[j][k].move();
//                  bestCar[j][k].changeAngle();
                  bestCar[j][k].detectCol(bestCar[j][k]);
                
                      
                    for(int m =0;m<numbEll;m++){
                      for(int n=0;n< steps+1;n++){  
                              bestCar[j][k].detectColCur(bestCar[j][k],curvePoints[m][n][n]);                                                 
                      }
                    }
                    for(int n=0;n<n3;n++){
                        for(int m=0;m<n4;m++){                              
                          if((bestCar[n][m].getColt() == true) && (bestCar[j][k] != bestCar[n][m])){
                            
                              bestCar[j][k].detectSelf(bestCar[j][k],bestCar[n][m]);      
                              
                          }
                        }                              
                      }
//                    for(int n=0;n<n1;n++){
//                        for(int m=0;m<n2;m++){                              
//                          if(myCar[n][m].getColt() == true){
//                            
//                              bestCar[j][k].detectColCars(bestCar[j][k],myCar[n][m]);      
//                              
//                          }
//                        }                              
//                      }
//                    for(int n=0;n<n5;n++){
//                        for(int m=0;m<n6;m++){                              
//                          if(rageCar[n][m].getColt() == true){
//                            
//                              bestCar[j][k].detectColCars(bestCar[j][k],rageCar[n][m]);      
//                              
//                          }
//                        }                              
//                      }
                bestCar[j][k].display();    
                if(bestCar[j][k].getDone() == false){
                  bestCar[j][k].scaleSize();
                }
                        
        }
        }
   }
//  
//  for(int n=0;n<n5;n++){
//    for(int m=0;m<n6;m++){
//      if((rageCar[n][m].getScale() == false) && (rageCar[n][m].getDone() == false) && (n == 0) && (m == 0)){
//                 rageCar[n][m].setScale(true);
//                 rageCar[n][m].setColt(true);
//          } if((rageCar[n][m].getDone() == true) && (n < n5-1) && (m < n6)){
//                rageCar[n+1][m].setScale(true);
//                rageCar[n+1][m].setColt(true);
//          } else if((rageCar[n][m].getDone() == true) && (n == n5-1) && (m < n6-1)){
//                rageCar[0][m+1].setScale(true);
//                rageCar[0][m+1].setColt(true);
//          }
//          if((rageCar[n][m].getScale() == true) && (rageCar[n][m].getDone() == false)){
//                
//                
////                  rageCar[n][m].move();  
////                  rageCar[n][m].changeAngle();
//                  rageCar[n][m].detectCol(rageCar[n][m]);
//                
//                    for(int j =0;j < numbEll;j++){
//                      for(int k=0;k < steps+1;k++){  
//                              rageCar[n][m].detectColCur(rageCar[n][m],curvePoints[j][k][k]);                                                 
//                      }
//                    }
//                    for(int j=0;j<n5;j++){
//                        for(int k=0;k<n6;k++){                              
//                          if((rageCar[j][k].getColt() == true) && (rageCar[n][m] != rageCar[j][k])){
//                            
//                              rageCar[n][m].detectSelf(rageCar[n][m],rageCar[j][k]);      
//                              
//                          }
//                        }                              
//                      }
//                     
//                     for(int j=0;j<n1;j++){
//                        for(int k=0;k<n2;k++){                              
//                          if(myCar[j][k].getColt() == true){
//                            
//                              rageCar[n][m].detectColCars(rageCar[n][m],myCar[j][k]);      
//                              
//                          }
//                        }                              
//                      }
//                      
//                     for(int j=0;j<n3;j++){
//                        for(int k=0;k<n4;k++){                              
//                          if(bestCar[j][k].getColt() == true){
//                            
//                              rageCar[n][m].detectColCars(rageCar[n][m],bestCar[j][k]);      
//                              
//                          }
//                        }                              
//                      } 
//                      
//                rageCar[n][m].display();
//                if(rageCar[n][m].getDone() == false){
//                  rageCar[n][m].scaleSize();
//                }                     
//        }
//    }
//  }
}

