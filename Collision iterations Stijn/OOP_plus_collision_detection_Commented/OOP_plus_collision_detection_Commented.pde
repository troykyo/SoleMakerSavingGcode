Car[][] myCar = new Car[10][7];
Car bestCar;

//Create Multiple tiny objects!
//Create one big object!
//Used the collision detecter to determine if the Big one hits the smaller ones... If so, It will destroy the smaller ones.

void setup(){
  size(960,960);
  for(int i=0;i<10;i++){
    for(int o=0;o<7;o++){            //i for number of objects in row; o for number of rows
      myCar[i][o] = new Car(300+i*30, 300+i*30 + o*30, 20, 20,255, 0, 8, true);
    }
  }
  bestCar = new Car(width/2,height/2,40,40,color(255,0,0), 5, 0, true);
  //Create Cars(x,y,width,height,color,speed in x direction, speed in y direction, visible(yes/no));
  
}



void draw(){
  background(color(200,200,200));
  for(int i=0;i<10;i++){
    for(int o=0;o<7;o++){
      myCar[i][o].display();
      myCar[i][o].move();
      myCar[i][o].detectCol(myCar[i][o], bestCar);        //detect for each object if it hits the big one
    }
  }
  bestCar.display();
  bestCar.move();
}

class Car{
  color c;
  float xpos;
  float ypos;
  float w;
  float h;
  float dx;
  float dy;
  boolean vis;
  
  Car(float xp,float yp, float w1, float h1, color c1, float sx, float sy, boolean v){
    c = c1;
    xpos = xp;
    ypos = yp;
    w = w1;
    h = h1;
    dx = sx;
    dy = sy;
    vis = v;
  }
  
  void display() {
    if(getVis() == true){
      rectMode(CENTER);
      fill(c);
      rect(xpos,ypos,w,h);
    }
  }  
  
  void detectCol(Car obj1, Car obj2){
    if(((obj2.getXpos()+ (obj2.getWidth()/2)) > (obj1.getXpos() - (obj1.getWidth()/2))) && ((obj2.getXpos() - (obj2.getWidth()/2)) < (obj1.getXpos() + (obj1.getWidth()/2))) && ((obj2.getYpos() + (obj2.getHeight()/2)) > (obj1.getYpos() - (obj1.getHeight()/2))) && ((obj2.getYpos() - (obj2.getHeight()/2)) < (obj1.getYpos() + (obj1.getHeight()/2)))){
      obj1.setVis(false);
        //If two objects hit one another... the small object will be turned off
        //Collision detection: If((rightSide obj2 > leftSide obj1)&&(leftSide obj2 < rightSide obj1)&&(downSide obj2 > upSide obj1)&&(upSide obj2 < downSide obj1))    { stuff}
    }
  }
  
  void move(){
    xpos = xpos + dx;
    if((xpos > width)||(xpos < 0)){
      dx = -dx;
    }
    ypos = ypos + dy;
    if((ypos > height)||(ypos < 0)){
      dy= -dy;
    }
  }
  
  float getXpos(){
    return xpos;
  }
  
  float getYpos(){
    return ypos;
  }
  float getWidth(){
    return w;
  }
  float getHeight(){
    return h;
  }
  boolean getVis(){
    return vis;
  }
  void setVis(boolean bol){
    vis = bol;
  }
}
