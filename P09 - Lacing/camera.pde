//**************************************
// 3D CAMERA
// Written by Jarek Rossignac,  June 2006 
//*************************************
boolean jumps=false;
pt Origin=new pt(0,0,0);
pt Eye=new pt(0,0,800);
cam C = new cam(Eye, Origin);
cam C1 = new cam(Eye, Origin);
cam C2 = new cam(Eye, Origin);
float svd=800;
//float fov=atan2(width/2,svd);
float fov=PI/3;
pt mark = new pt(0,0,0);
pt eye = new pt(0,0,0);

pt Cbox = new pt(width/2,height/2,0);                   // mini-max box center
float Rbox=1000;                                        // Radius of enclosing ball

void initView(Mesh M) { 
   M.computeBox(); Cbox.setTo(M.Cbox); Rbox=M.Rbox;
   r=int(9*Rbox/height); 
   C.F.setToPoint(Cbox); C.D=Rbox*2; 
   C.U.setTo(0,1,0); C.E.setToPoint(C.F); C.E.addVec(new vec(0,0,1)); C.pullE(); C.pose();
  }

class cam { 
  float D=10000, sD=D; 
  pt E = new pt(0,0,D); pt sE = new pt(0,0,D);
  pt F = new pt(0,0,0); pt sF = new pt(0,0,0); 
  vec U = new vec(0,1,0);
  vec I = new vec(1,0,0);  vec J = new vec(0,1,0); vec K = new vec(0,0,1);
  int px=0, py=0;

  cam (pt pE, pt pF) {E.setToPoint(pE); F.setToPoint(pF); D=E.disTo(F);};
  
  void apply() { camera(E.x,E.y,E.z,F.x,F.y,F.z,U.x,U.y,U.z);  };
  
  void setMark() {
    float x=float(mouseX-width/2)*2/width; float y=float(mouseY-height/2)*2/height; 
    mark.setToPoint(F); mark.addScaledVec(x*D,I); mark.addScaledVec(y*D,J);
    eye.setToPoint(E);
    };
 
  void write() {print("camera: ");     println("D="+D); 
    print("E="); E.write(); 
    print("F="); F.write(); 
    print("U="); U.write(); 
    println();};
  
  void anchor() {px=mouseX; py=mouseY; sE.setToPoint(E); sF.setToPoint(F); sD=D;};
  
  void snap() {E.setToPoint(sE); F.setToPoint(sF); D=sD;};  
  void snapD() {D=sD; println(">> snapped D="+D); };  
  
  void pose() {
    vec nK=F.vecTo(E);  
          if (nK.norm()>0.0001) {K.setToVec(nK);} else {println("keep K");}; 
    K.makeUnit(); 
    vec nI=cross(U,K);  
         if (nI.norm()<0.0001) {nI.setToVec(I); println("I=UxJ");}; 
    nI.makeUnit();   
    I.setToVec(nI);
    J.setToVec(cross(K,I)); 
    J.makeUnit(); 
    }

  void showPose() {vec II = I.make(); II.mul(100); stroke(250,20,20); II.show(F); vec JJ = U.make(); JJ.mul(100); stroke(0,200,50); JJ.show(F); }
  
  void jump (Mesh M) {
    F.setToPoint(M.g()); 
    vec N = M.triNormal(); N.makeUnit();
    E.setToPoint(M.triCenter()); 
    vec T = E.vecTo(F); float nT=T.norm(); E.addScaledVec(nT,N);  
    U.setToVec(N); U.back(); sD=6*nT; this.pullE(); this.pose(); 
 //   println(); println("sD="+sD); this.write(); 
    };
  
  void pullF() {float cD=F.disTo(E);  if (abs(cD)<0.001) {F.setToPoint(E); F.addScaledVec(D,K);} else {F.moveTowards((cD-D)/cD,E);};};
 
  void pullE() {float cD=F.disTo(E);  if (abs(cD)<0.001) {E.setToPoint(F); E.addScaledVec(D,K);} else {E.moveTowards((cD-D)/cD,F);};};
 
  void recomputeD() {D=E.disTo(F);};
 
  void fly(float s) {
    float r=width*2; float x=(mouseX-width/2)/r;   float y=(mouseY-height/2)/r; 
    F.addScaledVec(x,I); F.addScaledVec(y,J); F.addScaledVec(-s,K);
    };
    
  void Turn() {
    float x=-(mouseX-width/2)*D/width/100;   float y=-(mouseY-height/2)*D/height/100; 
    F.addScaledVec(x,I); F.addScaledVec(y,J); 
    if (cross(U,F.vecTo(E)).norm()<0.1) { F.addScaledVec(-x/10.0,I); F.addScaledVec(-y/10.0,J); };
    };
    
  void turn() {
    float x=-(mouseX-px)*D/width; float y=-(mouseY-py)*D/height; 
    F.setToPoint(sF); F.addScaledVec(x,I); F.addScaledVec(y,J);  
    if (cross(U,F.vecTo(E)).norm()<0.1) { F.addScaledVec(-x/10.0,I); F.addScaledVec(-y/10.0,J); };
    };
    
  void Pan() {
    float r=16*width/D; float x=-(mouseX-width/2)/r;   float y=-(mouseY-height/2)/r; 
    E.addScaledVec(x,I); E.addScaledVec(y,J);   
    if (cross(U,F.vecTo(E)).norm()<0.1) { F.addScaledVec(-x/10.0,I); F.addScaledVec(-y/10.0,J); };
    };
    
  void pan() {
    float r=width/D/2; float x=-(mouseX-px)/r;   float y=-(mouseY-py)/r;     
    E.setToPoint(sE); E.addScaledVec(x,I); E.addScaledVec(y,J);  
    if (cross(U,F.vecTo(E)).norm()<0.1) { F.addScaledVec(-x/10.0,I); F.addScaledVec(-y/10.0,J); };
    };

  void zoom() {
    float r=width/M.Rbox/2; float x=-(mouseX-px)/r;   float y=-(mouseY-py)/r; 
 //   E.setToPoint(sE); E.addScaledVec(x,I); 
    D=sD+y; 
    };
   
  void track (cam K) {float s=0.0005*M.nt; if (s<0.005) {s=0.005;}; if (s>0.25) {s=0.25;}; E.moveTowards(s,K.E); F.moveTowards(s,K.F); this.recomputeD(); U.addScaled(s,K.U); U.makeUnit(); this.pose(); this.anchor();}
  void setToCam (cam K) {E.setToPoint(K.E); F.setToPoint(K.F); this.recomputeD(); U.setToVec(K.U); U.makeUnit(); this.pose(); this.anchor();}
  void flyThrough(Mesh M, int c, vec normal){
    E.setToPoint(M.g(c));
    F.setToPoint(M.g(c-1));
    U.setToVec(normal);
    U.back();
    sD=1;
    this.pullF();
    this.pose();
  }
 }
