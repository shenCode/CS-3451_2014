// Triangle mesh viewer + corner table + subdivision + smoothing + simplificatioin + geodesics + isolation
// Written by Jarek Rossignac June 2006. Last modified November 2014
import processing.opengl.*;                // load OpenGL
String [] fn=  {"bunny.vts","horse.vts","torus.vts","tet.vts","fandisk.vts","squirrel.vts","venus.vts"};
int fni=0; int fniMax=fn.length;  

// ** SETUP **
void setup() { size(800, 800, OPENGL); setColors(); sphereDetail(6); //smooth();
  PFont font = loadFont("Courier-14.vlw"); textFont(font, 12);  // font for writing labels on screen
  M.declare(); M.makeGrid(10); M.init();
  initView(M);  
  } 
 
// ** DRAW **
void draw() {
  background(white); 
  perspective(PI/2.0,width/height,1.0,6.0*Rbox); 
  if (showHelpText) {camera(); translate(-290,-290,0); scale(1.7,1.7,1.0); showHelp(); showColors();  return; };
  lights(); directionalLight(0,0,128,0,1,0); directionalLight(0,0,128,0,0,1);
  translate(float(height)/2, float(height)/2, 0.0);     // center view wrt window  
  if ((!keyPressed)&&(mousePressed)) {C.pan(); C.pullE(); };
  if ((keyPressed)&&(mousePressed)) {updateView();}; 
  C1.track(C); C2.track(C1); C2.apply();  
  M.show();
  
  }

//***      KEY ACTIONS (details in keys tab)
void keyPressed() { keys(); };
void mousePressed() {C.anchor(); C.pose();   if (keyPressed&&(key=='m')) {C.setMark(); M.hitTriangle();};   };   // record where the cursor was when the mouse was pressed
void mouseReleased() {C.anchor(); C.pose(); };  // reset the view if any key was pressed when mouse was released 
