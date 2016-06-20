
class Car{
  color c;
  float xpos;
  float ypos;
  float w;
  float h;
  float dx;
  float dy;
  boolean vis;
  float ang;
  boolean doScale;
  boolean done;
  boolean coltrue;
  
  Car(float xp,float yp, float w1, float h1, color c1, float sx, float sy, boolean v, float angle, boolean ds, boolean d, boolean ct){
    c = c1;
    xpos = xp;
    ypos = yp;
    w = w1;
    h = h1;
    dx = sx;
    dy = sy;
    vis = v;    
    ang = angle;
    doScale = ds;
    done = d;
    coltrue = ct;
  }
  
  void scaleSize(){
    if(doScale == true){
        w = w +1;
        h = h +1;
    }
  }
  void display() {
    if(getVis() == true){
      rectMode(CENTER);
      noStroke();
      fill(c);
      rect(xpos,ypos,w,h);
    }
  }  
  
  void detectCol(Car obj1){
    if(((obj1.getXpos()+ (obj1.getWidth()/2)) > 800) && ((obj1.getXpos() - (obj1.getWidth()/2)) < 800) && ((obj1.getYpos() + (obj1.getHeight()/2)) > 100) && ((obj1.getYpos() - (obj1.getHeight()/2)) < 800)){
//      obj1.setVis(false);
      obj1.setScale(false);
      obj1.setDone(true);
        //If two objects hit one another... the small object will be turned off
        //Collision detection: If((rightSide obj2 > leftSide obj1)&&(leftSide obj2 < rightSide obj1)&&(downSide obj2 > upSide obj1)&&(upSide obj2 < downSide obj1))    { stuff}
    } else if(((obj1.getXpos()+ (obj1.getWidth()/2)) > 100) && ((obj1.getXpos() - (obj1.getWidth()/2)) < 100) && ((obj1.getYpos() + (obj1.getHeight()/2)) > 100) && ((obj1.getYpos() - (obj1.getHeight()/2)) < 800)){
//      obj1.setVis(false);
      obj1.setScale(false);
      obj1.setDone(true);
    } else if(((obj1.getXpos()+ (obj1.getWidth()/2)) > 100) && ((obj1.getXpos() - (obj1.getWidth()/2)) < 800) && ((obj1.getYpos() + (obj1.getHeight()/2)) > 100) && ((obj1.getYpos() - (obj1.getHeight()/2)) < 100)){
//      obj1.setVis(false);
      obj1.setScale(false);
      obj1.setDone(true);
    } else if(((obj1.getXpos()+ (obj1.getWidth()/2)) > 100) && ((obj1.getXpos() - (obj1.getWidth()/2)) < 800) && ((obj1.getYpos() + (obj1.getHeight()/2)) > 800) && ((obj1.getYpos() - (obj1.getHeight()/2)) < 800)){
//      obj1.setVis(false);
      obj1.setScale(false);
      obj1.setDone(true);
    }
  }
  
  void detectColCars(Car obj1, Car obj2){
    if(((obj2.getXpos()+ (obj2.getWidth()/2)) > (obj1.getXpos() - (obj1.getWidth()/2))) && ((obj2.getXpos() - (obj2.getWidth()/2)) < (obj1.getXpos() + (obj1.getWidth()/2))) && ((obj2.getYpos() + (obj2.getHeight()/2)) > (obj1.getYpos() - (obj1.getHeight()/2))) && ((obj2.getYpos() - (obj2.getHeight()/2)) < (obj1.getYpos() + (obj1.getHeight()/2)))){
      obj1.setScale(false);
      obj1.setDone(true);
        //If two objects hit one another... the small object will be turned off
        //Collision detection: If((rightSide obj2 > leftSide obj1)&&(leftSide obj2 < rightSide obj1)&&(downSide obj2 > upSide obj1)&&(upSide obj2 < downSide obj1))    { stuff}
    }
  }
  
  void detectSelf(Car obj1, Car obj2){
    if(((obj2.getXpos()+ (obj2.getWidth()/2)) > (obj1.getXpos() - (obj1.getWidth()/2))) && ((obj2.getXpos() - (obj2.getWidth()/2)) < (obj1.getXpos() + (obj1.getWidth()/2))) && ((obj2.getYpos() + (obj2.getHeight()/2)) > (obj1.getYpos() - (obj1.getHeight()/2))) && ((obj2.getYpos() - (obj2.getHeight()/2)) < (obj1.getYpos() + (obj1.getHeight()/2)))){
      obj1.setScale(false);
      obj1.setDone(true);
        //If two objects hit one another... the small object will be turned off
        //Collision detection: If((rightSide obj2 > leftSide obj1)&&(leftSide obj2 < rightSide obj1)&&(downSide obj2 > upSide obj1)&&(upSide obj2 < downSide obj1))    { stuff}
    }
  }
  
//  void detectColCur(Car obj2, Points obj1){
//    if(((obj2.getXpos()+ (obj2.getWidth()/2)) > obj1.getXpos()) && ((obj2.getXpos() - (obj2.getWidth()/2)) < obj1.getXpos()) && ((obj2.getYpos() + (obj2.getHeight()/2)) > obj1.getYpos()) && ((obj2.getYpos() - (obj2.getHeight()/2)) < obj1.getYpos())){
//      obj2.setScale(false);
//      obj2.setDone(true);
//        //If two objects hit one another... the small object will be turned off
//        //Collision detection: If((rightSide obj2 > leftSide obj1)&&(leftSide obj2 < rightSide obj1)&&(downSide obj2 > upSide obj1)&&(upSide obj2 < downSide obj1))    { stuff}
//    }
//  }
  
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
  
  void changeAngle(){
    ang = ang + (-0.2*PI + random(0.4*PI));
    dx = cos(ang);
    dy = sin(ang);
  }
  
  float getAng(){
    return ang;
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
  boolean getScale(){
    return doScale;
  }
  
  boolean getDone(){
    return done;
  }
  
  boolean getColt(){
    return coltrue;
  }
  void setVis(boolean bol){
    vis = bol;
  }
  void setScale(boolean bol){
    doScale = bol;
  }
  
  void setDone(boolean bol){
    done = bol;
  }
  
  void setColt(boolean bol){
    coltrue = bol;
  } 
}
