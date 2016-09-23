  // LecturesInGraphics: 
// Points-base source for project 05
// Steady patterns of strokes
// Template provided by Prof Jarek ROSSIGNAC
// Modified by student:  Shen Yang

//**************************** global variables ****************************
pts P = new pts(); // Guide points
pts S = new pts(); // points of stroke
int[] lineLengths = { 5, 4, 5, 4 };
float t=0.5, f=0, s=0;
boolean animate=true, showStrokes=true, showPoints = true, trigger = false, animated = false;

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(600, 600);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare().resetOnCircle(14);
  S.declare();
  
  pt TL = P(width/5, height/5);
  pt BR = P(4*width/5, 4*height/5);

  for (int i = 0; i < 5; i++) {
     linePoint(P, 0, i).setTo(P(TL.x, L(TL.y, BR.y, i/4f)));
     linePoint(P, 2, i).setTo(P(BR.x, L(TL.y, BR.y, i/4f)));
  }
  for (int i = 0; i < 4; i++) {
     linePoint(P, 1, i).setTo(P(L(TL.x, BR.x, i/3f), TL.y));
     linePoint(P, 3, i).setTo(P(L(TL.x, BR.x, i/3f), BR.y));
  }
}

/**
 * Draws the line with the given index (0-3).
 * @param P - storage pts object
 * @param index - point index value 0-4
 * */
void drawPolyline(pts P, int line) {
  for (int i = 0; i < lineLengths[line]-1; i++) {
    //edge(linePoint(P, line, i), linePoint(P, line, i+1));
  }
}

float L(float a, float b, float s) { return a*(1-s) + b*s; }

/**
 * Returns the point on line (line) at index (index).
 * @param P - storage pts object
 * @param line - line index value 0-4
 * @param index - point index value 0-4 or 0-5
 * */
pt linePoint(pts P, int line, int index) {
  if (line == 0) index = 4 - index;
  else if (line == 3) index = 3 - index;
  
  for (int i = 0; i < line; i++) 
    index += lineLengths[i]-1; // -1 because it wraps
  return P.G[index % P.nv];
}

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background

  // Draw strokes
  int[] colors = { 
    red, black, green, blue
  };
  for (int i = 0; i < lineLengths.length; i++) {
    pen(colors[i%colors.length], 2);
    drawPolyline(P, i);
  }
  
  
  //P.drawCurve(); Draw points
  if (showPoints) {
    pen(black, 1);
    int R = 15;
    for (int i = 0; i < P.nv; i++) {
      fill(white);
      show(P.G[i], R);
      fill(black);
      label(P.G[i], String.valueOf((char)('A'+i)));
    }

    // Draw color-coded indices
    vec offset = V(-R*2, 0);
    for (int line = 0; line < 4; line++) {
      fill(colors[(line%colors.length)]);
      pt M = P(0, 0);
      for (int i = 0; i < 4; i++) {
        pt p = linePoint(P, line, i);
        M.add(p);
        label(P(p, offset), String.valueOf(i));
      }
      M.scale(0.25f);
      label(P(M, S(2.5f, offset)), "Line " + line); 
      offset = R(offset);
    }  
  }
  
  noFill();
  
  if (animate){
   
   strokeWeight(3); 
   stroke(red); beginShape();
   for(float s = 0; s <= 1.0; s += 0.01) leftCurve(P.G, s, 0).v();
   endShape(); 
   
   strokeWeight(3); 
   stroke(green); beginShape();
   for(float s = 0; s <= 1.0; s += 0.01) rightCurve(P.G, s, 0).v();
   endShape(); 
  
   strokeWeight(3); 
   stroke(black); beginShape();
   for(float t = 0; t <= 1.0; t += 0.01) topCurve(P.G, 0, t).v();
   endShape(); 
   
   strokeWeight(3); 
   stroke(blue); beginShape();
   for(float t = 0; t <= 1.0; t += 0.01) downCurve(P.G, 0, t).v();
   endShape(); 
   
   strokeWeight(1); 
   stroke(#E3E0E0);
   edge(topCurve(P.G, 0, (float)mouseX/width), downCurve(P.G, 0, (float)mouseX/width));
   strokeWeight(1); 
   stroke(#E3E0E0);
   edge(leftCurve(P.G, (float)mouseY/width,0), rightCurve(P.G, (float)mouseY/width, 0));
  
  if(!animated){
    strokeWeight(1);
    stroke(black); beginShape();
    for (float s = 0; s < 1.01; s += 0.01)  v(coons(P.G, s, (float)mouseX/width));
    endShape();beginShape();
    for (float t = 0; t < 1.01; t += 0.01)  v(coons(P.G, (float)mouseY/width, t));
    endShape(); 
  } 


  if(animated){
    
    if(trigger){
      if(t < 0) { trigger = false;} else t -= 0.01;
    }
    else if(!trigger){
      if(t > 1) { trigger = true;} else t += 0.01;
    }
    
    strokeWeight(2);
    stroke(black); beginShape();
    for (float s = 0; s < 1.01; s += 0.01)  v(coons(P.G, s, t));
    endShape();  
  }
  

  if (showStrokes) {
    noFill(); 
    stroke(blue); 
    S.drawCurve();
  } 
  
  displayHeader();
  if (scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if (filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++, 4)+".tif");  
  change=false; // to avoid capturing frames when nothing happens
  scribeHeader("s="+s+", t="+nf(t,0,2),1); 

}  // end of draw()

}
//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
  // till it is released or another key is pressed or released
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
name ="Student: Shen Yang", 
menu="Use 'a' to start and stop animation.", 
guide="drag to edit curve vertices"; // help info


