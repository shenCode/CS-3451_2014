// LecturesInGraphics: 
// Points-base source for project 03
// Steady patterns of strokes
// Template provided by Prof Jarek ROSSIGNAC
// Modified by student:  Shen Yang
// Collaboration statement: Worked with Bo Chen on how it should be designed and the Math behind it.

//**************************** global variables ****************************
pts P = new pts(); // vertices of triangles
pts Q = new pts(); // points of destination cube
pts R = new pts();
pt cp = new pt(300,300); // init the centroid point
pt cr = new pt(300, 300); // init centroid point for r
pt cls, clsq, clsr; 
pt cq = new pt(300,300);
pt press;
float distance, distanceq, distancer;  // drag point to centroid or ABCD distance
float t=0, f=0;
Boolean animate=false, showTriangles=true, showStrokes=true;
pt A0, B0, C0, D0, A1, B1, C1, D1;
float time = 0;
pt[] initial;
vec pressToC0, pressToC1;  // press point to centroid vector
vec cornerToC0, cornerToC1;  //closest corner point to centroid vector
float angle0, angle1;  //angle between press vector and corner vector
Boolean switch0 = true;
Boolean switch1 = true;
Boolean case0, case1;  // case0 is when the mouse press closer to big rectangle, case1 is mouse press closer to small rectangle.

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
    size(600, 600);            // window size
    frameRate(30);             // render 30 frames per second
    smooth();                  // turn on antialiasing
    myFace = loadImage("data/face.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
    P.declare().resetOnCircle(4);
    Q.declare().resetOnCircle(new pt(50,500),4);
    R.declare().resetOnCircle(4);
}

//**************************** display current frame ****************************
void draw() {      // executed at each frame
    background(white); // clear screen and paints white background
    A0=P.G[0]; B0=P.G[1]; C0=P.G[2]; D0 = P.G[3]; 
    A1=Q.G[0]; B1=Q.G[1]; C1=Q.G[2]; D1 = Q.G[3];
   
    initial = P.G;
    if(showTriangles) {
        pen(black,3); edge(A0,B0); edge(A0,D0); edge(B0,C0); edge(C0, D0); 
        pen(red,3); edge(A1,B1); edge(A1,D1); edge(B1,C1); edge(C1, D1);
        pen(green, 3); edge(R.G[0], R.G[1]); edge(R.G[0], R.G[3]); edge(R.G[1], R.G[2]); edge(R.G[2], R.G[3]); 
        fill(black); 
    }
 
    if (animate) {
        for (int i = 0; i < P.G.length; i++) {
            vec V1 = V(A0, B0);
            vec V2 = V(A1, B1);
            float m = n(V1)/n(V2);
            float alpha = angle(V1, V2);
            float c = cos(alpha);
            float s = sin(alpha);
            float D = sq(c*m-1)+sq(s*m);
            float x = c*m*P.G[i].x-Q.G[i].x-s*m*P.G[i].y;
            float y = c*m*P.G[i].y-Q.G[i].y+s*m*P.G[i].x;
            pt F = new pt(((x*(c*m-1)+y*s*m)/D), (y*(c*m-1)-x*s*m)/D);
            float mt = (float)(Math.pow(m, time));
            vec w = W(mt,(V(F, initial[i])));
            pt p = new pt(w.x, w.y);
            pt rotated = p.rotate(time*alpha, p);
            pt Fadd = F.add(rotated);
            P.G[i] = new pt(Fadd.x, Fadd.y);
            time+=1/300000f;
        }
    }
      
    displayHeader();
    if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
    if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  
    change=false; // to avoid capturing frames when nothing happens
    P.showPicked();
}  // end of draw()
  
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
    if(key=='a') {animate = !animate; time = 0;
        for (int i = 0; i < R.G.length; i++) {
            P.G[i] = R.G[i]; 
        }
    }
    change=true;
}

void mousePressed() {  // executed when the mouse is pressed
if (!animate) {
    cp = P.Centroid();  //tracking the centroid 
    cq = Q.Centroid();
    cr = R.Centroid();
    press = new pt(pmouseX, pmouseY);
    if(!keyPressed) { // used to pick the closest vertex of C to the mouse
        cls = P.pickClosests(Mouse(), cp);  // get the closest point from mouse
        clsq = Q.pickClosests(Mouse(), cq);
        clsr = R.pickClosests(Mouse(), cr);
        distance = d(press, cls);
        distanceq = d(press, clsq);
        distancer = d(press, clsr);
    }
    if (!cls.equals(cp)) {
        //closest vector for green rectangle
         pressToC0 = V(cls, Pmouse());
         cornerToC0 = V(cls, cp);  
        angle0 = angle(pressToC0, cornerToC0);
       
        //closest vector info for red rectangle
        pressToC1 = V(clsq, Pmouse());
        cornerToC1 = V(clsq, cq);
        angle1 = angle(pressToC1, cornerToC1);
       
        case0 = d(Pmouse(), cp) < d(Pmouse(), cq);
        case1 = d(Pmouse(), cq) <= d(Pmouse(), cp);
    }
  
  change=true;
  }
}

void mouseDragged() {
 
    if (!animate) {
    if (!keyPressed || (key==' ')) {
    if (clsr.equals(cr)) { //when the mouse close to centroid
        R.dragAll();
        for (int i = 0; i < R.G.length; i++) {
           P.G[i] = R.G[i]; 
        }
    }
    else if(clsq.equals(cq)) {
        Q.dragAll(); 
    }
    else if (case0) {
        switch1 = !switch1;
        if(!V(cls, Mouse()).equals(pressToC0)){
            R.scaleAll(cr,Mouse(),Pmouse()); // scale all vertices with respect to their center of mass     
        }
        if(angle(pressToC0, cornerToC0) == (angle0)) {
            R.rotateAll(cr,Mouse(),Pmouse()); // turn all vertices around their center of mass      
        }
        if (!V(cls, Pmouse()).equals(pressToC0) && angle(pressToC0, cornerToC0) == (angle0)){
            R.scaleAll(cr,Mouse(),Pmouse()); // scale all vertices with respect to their center of mass
            R.rotateAll(cr,Mouse(),Pmouse()); // turn all vertices around their center of mass
        }
    }
    else if (case1) {  
        switch0 = !switch0;
        if(!V(clsq, Pmouse()).equals(pressToC1)) {
            Q.scaleAll(cq,Mouse(),Pmouse()); // scale all vertices with respect to their center of mass     
        }
        if(angle(pressToC1, cornerToC1) == (angle1)) {
            Q.rotateAll(cq,Mouse(),Pmouse()); // turn all vertices around their center of mass      
        }
        if (!V(clsq, Pmouse()).equals(pressToC1) && angle(pressToC1, cornerToC1) == (angle1)) {
            Q.scaleAll(cq,Mouse(),Pmouse()); // scale all vertices with respect to their center of mass
            Q.rotateAll(cq,Mouse(),Pmouse()); // turn all vertices around their center of mass
        } 
    }
}
    for (int i = 0; i < R.G.length; i++) {
        P.G[i] = R.G[i]; 
    }
} 

    change=true;
}  

//**************************** text for name, title and help  ****************************
String title ="Steady pattern of strokes", 
       name ="Student: Shen Yang 9/8/2014",
       help="press a to animate, press again to stop.",
       menu=" ?:(show/hide) help, !:snap picture, ~:(start/stop) recording frames for movie, Q:quit",
       guide="drag to edit triangle vertices, space to draw stroke, 'S', 'T' to toggle display"; // help info





