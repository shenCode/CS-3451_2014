  // LecturesInGraphics: 
// Points-base source for project 05
// Steady patterns of strokes
// Template provided by Prof Jarek ROSSIGNAC
// Modified by student:  Peilin Li

//**************************** global variables ****************************
pts P = new pts(); // Guide points
pts S = new pts(); // points of stroke
ball Ball, Ball2;
failBall Ball3;
float t=0.5, f=0, s=0;
boolean animate=true, showStrokes=true, showPoints = true, trigger = false, animated = false, move = false, show3 = true;
public int state;

//**************************** initialization ****************************
void setup() {               // executed once at the beginning 
  size(600, 600);            // window size
  frameRate(60);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare();
  P.addPt(100, 400);
  P.addPt(200, 500);
  P.addPt(300, 550);
  P.addPt(400, 500);
  P.addPt(500, 400);
  Ball = new ball(P.G, 0.05);
  Ball2 = new ball(P.G, 0.05);
  Ball3 = new failBall(P.G, 0.05);
  
}

float L(float a, float b, float s) { return a*(1-s) + b*s; }

void drawGround(){
  stroke(black);
  beginShape();
  for(float t = 0; t < 1.01; t+= 0.01){
      v(groundCurve(P.G, t));
  }
  endShape();
}

void showPoints(pts P){
  stroke(blue);
  for(int i = 0; i < P.nv; i++){
    show(P.G[i], 15);
  }
}

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white backgrou
  //println(computeCurveLength(P.G));
  noFill();
  

  drawGround();
  showPoints(P);
    if (move) {
  Ball.update(1);
  Ball2.update(2);
  Ball.computeA(1);
  Ball2.computeA(2);
  if (show3) {
  Ball3.update(P.G);
  Ball3.computeA();
  }
  }
    Ball.drawBall(1);
  Ball2.drawBall(2);
  if (show3) {
  Ball3.drawBall();
  }
  displayHeader();
  if (scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if (filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++, 4)+".tif");  
  change=false; // to avoid capturing frames when nothing happens
  scribeHeader("s="+s+", t="+nf(t,0,2),1); 
}  // end of draw()


//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
  // till it is released or another key is pressed or released
//  if (key=='1') state = 1;
//  if (key=='2') state = 2;
if (key=='m') move = !move;
if (key=='r') restart();
if (key == 'z') show3 = !show3;
  if (key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if (key=='!') snapPicture(); // make a picture of the canvas
  if (key=='~') { 
    filming=!filming;
  } // filming on/off capture frames into folder FRAMES
  if (key=='s') P.savePts("data/pts");   
  if (key=='l') P.loadPts("data/pts"); 
  if (key=='p') showPoints = !showPoints;
  if (key=='S') showStrokes=!showStrokes;   // quit application
  if (key=='Q') exit();  // quit application
  if (key=='a') animated=!animated; t=(float)mouseX/width;
  change=true;
  
}

void restart() {
  Ball = new ball(P.G, 0.05);
  Ball2 = new ball(P.G, 0.05);
  Ball3 = new failBall(P.G, 0.05);
}

void mousePressed() {  // executed when the mouse is pressed
  if (keyPressed && key==' ') S.empty();
  if (!keyPressed) P.pickClosest(Mouse()); // used to pick the closest vertex of C to the mouse
  change=true;
}

void mouseDragged() {
  if (!keyPressed || (key=='a')) P.dragPicked();   // drag selected point with mouse
  if (keyPressed) {
    if (key=='.') f+=2.*float(mouseX-pmouseX)/width;  // adjust current frame   
    if (key=='t') {
      P.dragAll();
      S.dragAll();
    } // move all vertices
    if (key=='r') {
      P.rotateAll(ScreenCenter(), Mouse(), Pmouse());
      S.rotateAll(ScreenCenter(), Mouse(), Pmouse());
    } // turn all vertices around their center of mass
    if (key=='z') {
      P.scaleAll(ScreenCenter(), Mouse(), Pmouse()); 
      S.scaleAll(ScreenCenter(), Mouse(), Pmouse());
    } // scale all vertices with respect to their center of mass
    if (key==' ') S.addPt(Mouse());
  }
  change=true;
}  

//**************************** text for name, title and help  ****************************
String title ="Coon Patch and Neville Interpolation", 
name ="Student: Peilin Li", 
menu="?:(show/hide) help, !:snap picture, ~:(start/stop) recording frames for movie, Q:quit", 
guide="drag to edit curve vertices"; // help info


