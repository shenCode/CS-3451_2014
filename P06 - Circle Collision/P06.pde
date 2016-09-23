// LecturesInGraphics: 
// Points-base source for project 03
// Steady patterns of strokes
// Template provided by Prof Jarek ROSSIGNAC
// Modified by student:  Bo Chen && Shen Yang

//**************************** global variables ****************************
pts P = new pts(); // vertices of triangles
pts S = new pts(); // points of stroke
float t=0, f=0;
Boolean animate=true, showTriangles=true, showStrokes=true, showDisk = true;
pt A, B, C, D, E, F, OA, OB, OC, OD, OE, OF, cls, press, NA, NB, NC, ND, NE, NF;
float radA, radB, distance1, distance2, oldradA, oldradB;
float vx=0, vy=0, vx1= 0, vy1=0; // velocities
vec VA, VB;
boolean collide, firstCollide;
float pace = 0.5;
//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(600, 600);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  myFace2 = loadImage("data/face.jpg"); // loads image from file face2.jpg in folder data  
  A = new pt(100, 300);
  B = new pt(450, 300);
  C = new pt(A.x+50, A.y);
  D = new pt(B.x-50, B.y);
  System.out.println("SETUP");
  radA = 50;
  radB = 50;
  VA = V(A, C);
  VB = V(B, D);
  P.declare().resetOnCircle(4);
  firstCollide = false;
}

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background

  
  noFill(); stroke(black); strokeWeight(3); showDisk(A.x, A.y, radA);
  noFill(); stroke(black); strokeWeight(3); showDisk(B.x, B.y, radB);
  E = new pt(A.x, A.y+radA);
  F = new pt(B.x, B.y+radB);
  //VA information
  P.G[0] = A; P.G[1] = B; P.G[2] = C; P.G[3] = D; P.G[4] = E; P.G[5] = F;
  vx = VA.x/10;
  vy = VA.y/10;
   
   //VB information

  vx1 = VB.x/10;
  vy1 = VB.y/10;
  
  
 
  if (!animating){
    fill(white); strokeWeight(2);
    A.show(10);
    B.show(10);
    C.show(10);
    D.show(10);
    E.show(10);
    F.show(10);
   
    OA = new pt(A.x, A.y);
    OB = new pt(B.x, B.y);
    OC = new pt(C.x, C.y);
    OD = new pt(D.x, D.y);
    A.label("A"); B.label("B"); C.label("C"); D.label("D"); E.label("E"); F.label("F");
    arrow(A, V(A, C)); arrow(B, V(B, D));
    

    
    
    t = 0;
  }
  t += 0.5;
 
  //if(showStrokes) {noFill(); stroke(blue); S.drawCurve();  }f 

  displayHeader();
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  
  change=false; // to avoid capturing frames when nothing happens
  
  
  vec V = new vec(vx1-vx, vy1-vy);
  vec AB = new vec(OB.x-OA.x, OB.y-OA.y);
  float c = dot(AB, AB) - (radA+radB)*(radA+radB);
  float a = dot(V, V);
  float b = 2*dot(AB, V);
  float r = (-b-sqrt(b*b-4*a*c))/(2*a);
  noFill();
  stroke(green); strokeWeight(1); 
  if (showDisk) {
  showDisk(OA.x + r*vx, OA.y + r*vy, radA);
  showDisk(OB.x + r*vx1, OB.y + r*vy1, radB);

  }
  if(animating) {
    
    A.x = OA.x + t*vx; A.y =OA.y + t*vy; C.x = OC.x + t*vx; C.y = OC.y + t*vy;   // move the blue point by its current velocity 
    B.x = OB.x + t*vx1; B.y = OB.y + t*vy1; D.x =OD.x + t*vx1; D.y = OD.y + t*vy1;
    if (d(A, B) <= (radA + radB)){
      collide = true;
    }
      
    if(collide && !firstCollide){
      System.out.println("Collision");
      collision();
      collide = false;
      firstCollide = true;
    }
      
  }  
}  // end of draw()
  
//**************************** determine collision ****************************
void collision(){
  vec tempA = V(VA.x, VA.y);
  float massConstA = (2*radB*radB) / (radA*radA + radB*radB);
  VA = VA.add(S(massConstA, VB.add(M(VA))));
  println("VA.x = " + VA.x);
  println("VA.y = " + VA.y);
  float massConstB = (2*radA*radA) / (radA*radA + radB*radB);
  VB = VB.add(S(massConstB, tempA.add(M(VB))));
  println("VB.x = " + VB.x);
  println("VB.y = " + VB.y);
  t = 0;
  OA = new pt(A.x, A.y);
  OB = new pt(B.x, B.y);
  OC = new pt(C.x, C.y);
  OD = new pt(D.x, D.y);
  showDisk = false;
}
  
void showVecData(){
  println("VA.x = " + VA.x);
  println("VA.y = " + VA.y);
  println("VB.x = " + VB.x);
  println("VB.y = " + VB.y);
}  
  


//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
                    // till it is released or another key is pressed or released
  if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if(key=='!') snapPicture(); // make a picture of the canvas
  if(key=='~') { filming=!filming; } // filming on/off capture frames into folder FRAMES
  if(key=='s') P.savePts("data/pts");  
  if(key=='a') animating=!animating;  // quit application 
  if(key=='f') showVecData(); 
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='S') showStrokes=!showStrokes;   // quit application
  if(key=='T') showTriangles=!showTriangles;  // quit application
  if(key=='Q') exit();  // quit application
  change=true;
  }

void mousePressed() {  // executed when the mouse is pressed
  
  cls = P.pickClosests(Mouse(), null);
  press = Mouse();
  NA = new pt(A.x, A.y);
  NB = new pt(B.x, B.y);
  NC = new pt(C.x, C.y);
  ND = new pt(D.x, D.y);
  NE = new pt(E.x, E.y);
  NF = new pt(F.x, F.y);
  change=true;
    distance1 = d(A, new pt(mouseX, mouseY));
    distance2 = d(B, new pt(mouseX, mouseY)); 
    oldradA = radA;
    oldradB = radB; 
   if(mouseX == C.x && mouseY == C.y){
     C.moveWithMouse();
   }
  }

void mouseDragged() {
  float temp1, temp2;
  temp1 = d(A, new pt(mouseX, mouseY));
  temp2 = d(B, new pt(mouseX, mouseY));
  
  if (!animating){
    if(!keyPressed || (key==' ')){
      
       if (isSame(NA, cls)) {
         //scale circle
         if(d(press, NE) < d(press, cls)){
           E = new pt(E.x+(mouseX-pmouseX), E.y+(mouseY-pmouseY));
           radA = radA + d(Mouse(), A) - d(Pmouse(), A);
         }
         //move cirle
         else{
           A = new pt(A.x+(mouseX-pmouseX), A.y+(mouseY-pmouseY));
           C = new pt(C.x+(mouseX-pmouseX), C.y+(mouseY-pmouseY));
         }                            
       }
       else if (isSame(NB, cls)) {  
        //scale circle 
          if (d(press, NF) < d(press, cls)){
            E = new pt(E.x+(mouseX-pmouseX), E.y+(mouseY-pmouseY));
            radB = radB + d(Mouse(), B) - d(Pmouse(), B);
          } 
          //move circle
          else{
          B = new pt(B.x+(mouseX-pmouseX), B.y+(mouseY-pmouseY));   
          D = new pt(D.x+(mouseX-pmouseX), D.y+(mouseY-pmouseY));         
             
          }    
       }
       // move B D 
       else if (isSame(NC, cls)) {
        C = new pt(C.x+(mouseX-pmouseX), C.y+(mouseY-pmouseY));
      }
       else if (isSame(ND, cls)){
        D = new pt(D.x+(mouseX-pmouseX), D.y+(mouseY-pmouseY));   
       }     
    }    
  }

  VA = V(A, C);
  VB = V(B, D); 

  change=true;
  }  

//**************************** scaling method  ****************************
float scaleAll(float s, pt p){
  float scale = d(p, new pt(mouseX, mouseY))/s;
  return scale ;
}

//**************************** text for name, title and help  ****************************
String title ="Steady pattern of strokes", 
       name ="Student: Bo Chen && Shen Yang",
       menu="?:(show/hide) help, !:snap picture, ~:(start/stop) recording frames for movie, Q:quit",
       guide="drag to edit triangle vertices, space to draw stroke, 'S', 'T' to toggle display"; // help info



