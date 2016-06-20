class SETUP{
  int S = 0;
  void reset(){
    S = 0;
  }
  
  void delta(char key){
    switch(S){
    case 0: if (key == '4') S = 1; else if (key == '3') S = 2; else if (key == '9') {S = 3; s = 0.5;} else S = 0; break;
    case 1: if(key == '1') {S = 3; SIZE = 41; s = 0.949;} else if (key == '3'){S = 3; SIZE = 43; s = 1;} else if (key == '5'){S = 3; SIZE = 45; s = 1/0.955;} else S = 0; break;
    case 2: if(key == '9') {S = 3; SIZE = 39; s = 0.892;} else S = 0; break;
    case 3: S = 3; break;
    }
  }
  boolean accept(){
    return(S == 3);
  }
}// end class