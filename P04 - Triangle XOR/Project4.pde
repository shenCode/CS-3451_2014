import java.util.*;
// LecturesInGraphics: 
// Points-base source for project 03
// Steady patterns of strokes
// Template provided by Prof Jarek ROSSIGNAC
// Modified by student:  ??? ???

//**************************** global variables ****************************
pts P = new pts(); // vertices of triangles
pts S = new pts(); // points of stroke
ArrayList<pt> G = new ArrayList<pt>();
ArrayList<Integer> V = new ArrayList<Integer>();
ArrayList<Integer> N = new ArrayList<Integer>();
ArrayList<Integer> V1 = new ArrayList<Integer>();
ArrayList<Integer> N1 = new ArrayList<Integer>();
ArrayList<Integer> L = new ArrayList<Integer>();
ArrayList<pt> Intersections = new ArrayList<pt>();
float t=0, f=0;
Boolean animate=true, showTriangles=true, showStrokes=true;
vec AB,BC, CA, DE, EF, FD;
vec AD, AE, DA, DB;
pt A, B, C, D, E, F;
int ne = 6;
int nv = -1;
int v = -1;
boolean changed = false;
boolean doBreak = false;
int state = 0;

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(600, 600);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/face.jpg");  // loads image from file face.jpg in folder data, replace it with a clear pic of your face
  myFace2 = loadImage("data/face2.jpg"); // loads image from file face2.jpg in folder data
  P.declare().resetOnCircle(6);
  
  // initialize G
  initG();


}

//**************************** display current frame ****************************
void initG() {
  G = new ArrayList<pt>();
  V = new ArrayList<Integer>();
  V1 = new ArrayList<Integer>();
  N = new ArrayList<Integer>();
  N1 = new ArrayList<Integer>();
  L = new ArrayList<Integer>();
  Intersections = new ArrayList<pt>();
  ne = 6;
  nv = 6;
  v = 6;
 for (int i = 0; i < 6; i++) {
     G.add(P.G[i]);
     V.add(i);
  }
  N.add(1);  
  N.add(2);  
  N.add(0);  
  N.add(4); 
  N.add(5); 
  N.add(3);  
}
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  A=P.G[0]; B=P.G[1]; C=P.G[2]; 
  D=P.G[3]; E=P.G[4]; F=P.G[5]; 
  fillColor();
   if(showTriangles) {
    pen(green,3); edge(A,B); edge(A,C); edge(B,C); 
    pen(blue,3); edge(D,E); edge(D,F); edge(E,F);  
    pen(black,2); P.draw(white);
    fill(red); 
    label(A,"A"); label(B,"B"); label(C,"C");
    label(D,"D"); label(E,"E"); label(F,"F");  
    }
 

  displayHeader();
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  
  change=false; // to avoid capturing frames when nothing happens
  nv = G.size();   
  for (int i = 0; i < nv; i++) {
   label(G.get(i), Integer.toString(i)); 
  }
  if (changed) {
    initG();
    for (int i = 0; i < 3; i++) {
      doBreak = false;
      findIntersection();
      state = 1;
      doBreak = false;
      findIntersection();
      state = 0;
    }
//    System.out.println("Table of G: ");
//    for (int i = 0; i < G.size(); i++) {
//     System.out.println(i); 
//    }
//    System.out.println("Table of E: ");
//    for (int i = 0; i < V.size(); i++) {
//     System.out.println(i + "   " + V.get(i) + "   " + N.get(i)); 
//    }
    for (int i = 0; i < V.size(); i++) {
       V1.add(V.get(i));
      N1.add(V.get(N.get(i)));
     System.out.println(V1.get(i) + " " + N1.get(i));
    
    }
    ArrayList<Integer> tmp = new ArrayList<Integer>();
    ArrayList<pt> V2 = new ArrayList<pt>();
    ArrayList<pt> N2 = new ArrayList<pt>();
    int pointer = 0;
    int counter = 5;
    while (counter > 0) {
     counter--;
     }
    

  }
  textSize(15);
  changed = false;
      for (int i = 0; i < Intersections.size(); i++) {
       show(Intersections.get(i)); 

    }
  
}  // end of draw()





//**************************** when triangles ccw, fill gray ****************************
void fillColor(){
  AB = V(P.G[0], P.G[1]);
  BC = V(P.G[1], P.G[2]);
  CA = V(P.G[2], P.G[0]);
  DE = V(P.G[3], P.G[4]);
  EF = V(P.G[4], P.G[5]);
  FD = V(P.G[5], P.G[3]);
  
  AD = V(P.G[0], P.G[3]);
  AE = V(P.G[0], P.G[4]);
  DA = V(P.G[3], P.G[0]);
  DB = V(P.G[3], P.G[1]);
  
  
  float ccw0 = det(AB, BC);
  float ccw1 = det(DE, EF);
  
  if (ccw0 < 0 && ccw1 >= 0){
    fill(gray);
    triangle(P.G[0].x, P.G[0].y, P.G[1].x, P.G[1].y, P.G[2].x, P.G[2].y);    
  }
  else if (ccw0 >=0 && ccw1 < 0){
    fill(gray);
    triangle(P.G[3].x, P.G[3].y, P.G[4].x, P.G[4].y, P.G[5].x, P.G[5].y);  
  }
  else if (ccw0 < 0 && ccw1 < 0){
    fill(gray);
    triangle(P.G[0].x, P.G[0].y, P.G[1].x, P.G[1].y, P.G[2].x, P.G[2].y);
    triangle(P.G[3].x, P.G[3].y, P.G[4].x, P.G[4].y, P.G[5].x, P.G[5].y);
  }
 
}

  
//**************************** crossion ****************************

void findIntersection() {
 pen(black, 3);
 int counter = G.size();
  for (int i = 0; i < V.size(); i++) {
    for (int j = i+1; j < N.size(); j++) {
       if (cross(G.get(V.get(i)), G.get(V.get(N.get(i))), G.get(V.get(j)), G.get(V.get(N.get(j))))) {
         pt intersection = getIntersection(G.get(V.get(i)), G.get(V.get(N.get(i))), G.get(V.get(j)), G.get(V.get(N.get(j))));
         G.add(intersection);
         Intersections.add(intersection);
         v = nv;
         nv++;
         
         int edgeNum1 = findEdge(V.get(i), V.get(N.get(i)));
         int edgeNum2 = findEdge(V.get(j), V.get(N.get(j)));
         if (state == 0){
         if(edgeNum1 != -1){
            insert(v, edgeNum1);
         }
         if(edgeNum2 != -1){
            insert(v, edgeNum2);
         }
         }
         else if (state == 1) 
         {
             if(edgeNum2 != -1){
            insert(v, edgeNum2);
         }
         if(edgeNum1 != -1){
            insert(v, edgeNum1);
         }
         }
         doBreak = true;
         break;
       }       
    }
    if (doBreak) {break;}
  }
}

void insert(int v, int e) {
  System.out.println("Inserting v: " + v + " e: " + e);
   V.add(v);
   N.add(N.get(e));
   N.set(e, ne);
   ne++;
}

void rewire(int e1, int e2) {
  int n = N.get(e1);
  N.set(e1, N.get(e2));
  N.set(e2, n);
}

//**************************** a function can find the edge number ****************************
int findEdge(int v, int n){
  int tempV = -1;
  int tempN = -1;
  for (int i = 0; i < V.size(); i++ ){
    for (int j = 0; j< N.size(); j++){
      tempV = V.get(i);
      tempN = N.get(j);
      if( tempV == v && tempN == n){
        return i;
      }
     }
  }
  System.out.println("can not find such edge.");
  return -1;
  
}

boolean cross(pt A, pt B, pt D, pt E) {
  AB = V(A, B);
  AD = V(A, D);
  AE = V(A, E);
  DE = V(D, E);
  DA = V(D, A);
  DB = V(D, B);
  if (A.equals(B) || B.equals(D) || D.equals(E) || E.equals(A)) {
     return false; 
  }
  return (det(AB, AD) > 0 != det(AB, AE) > 0) && (det(DE, DA) >0 != det(DE, DB) > 0);
}
pt getIntersection(pt A, pt B, pt C, pt D) {
    vec nAC = M(V(A, C));
    vec AB0 = R(V(A, B));
    vec CD = V(C, D);
    float t = dot(nAC, AB0)/dot(CD, AB0);
    vec tCD = W(t, CD);
    pt E = P((C.x + tCD.x),(C.y + tCD.y));
    return E;
}
  
//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
                    // till it is released or another key is pressed or released
  if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if(key=='!') snapPicture(); // make a picture of the canvas
  if(key=='~') { filming=!filming; } // filming on/off capture frames into folder FRAMES
  if(key=='s') P.savePts("data/pts");   
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='S') showStrokes=!showStrokes;   // quit application
  if(key=='T') showTriangles=!showTriangles;  // quit application
  if(key=='Q') exit();  // quit application
  change=true;
  }


void mousePressed() {  // executed when the mouse is pressed
  if(keyPressed && key==' ') S.empty();
  if(!keyPressed) P.pickClosest(Mouse()); // used to pick the closest vertex of C to the mouse
  change=true;
  changed = true;
  }

void mouseDragged() {
  if (!keyPressed || (key=='a')) P.dragPicked();   // drag selected point with mouse
  if (keyPressed) {
      if (key=='.') f+=2.*float(mouseX-pmouseX)/width;  // adjust current frame   
      if (key=='t') {P.dragAll();S.dragAll();} // move all vertices
      if (key=='r') {P.rotateAll(ScreenCenter(),Mouse(),Pmouse());S.rotateAll(ScreenCenter(),Mouse(),Pmouse());} // turn all vertices around their center of mass
      if (key=='z') {P.scaleAll(ScreenCenter(),Mouse(),Pmouse()); S.scaleAll(ScreenCenter(),Mouse(),Pmouse());} // scale all vertices with respect to their center of mass
      if (key==' ') S.addPt(Mouse());
      }
  change=true;
  changed = true;
  }  

//**************************** text for name, title and help  ****************************
String title ="Steady pattern of strokes", 
       name ="Student: Xxxxxxx YYYYYYYY",
       menu="?:(show/hide) help, !:snap picture, ~:(start/stop) recording frames for movie, Q:quit",
       guide="drag to edit triangle vertices, space to draw stroke, 'S', 'T' to toggle display"; // help info



