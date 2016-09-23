/**************************** HEADER ****************************
 LecturesInGraphics: Template for Processing sketches in 2D
 Template author: Jarek ROSSIGNAC
 Class: CS3451 Fall 2014
 Student: Bo Chen && Shen Yang
 Project number: P01
 Project title: Bouncing Rectangles
 Date of submission: 8/26/2014
*****************************************************************/


//**************************** global variables ****************************
float x, y; // coordinates of blue point controlled by the user
float vx=1, vy=0; // velocities
float xb, yb; // coordinates of base point, recorded as mouse location when 'b' is released
boolean mode1 = true; // controls mode 1
boolean mode2 = false; // controls mode 2
boolean mode3 = false; // controls mode 3
boolean mode4 = false; // controls mode 4
boolean mode5 = false; // controls mode 5
float gravity = 0.1;

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(600, 600);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/face.jpg");  // loads image from file face.jpg in folder data, replace it with a clear pic of your face
  myFace2 = loadImage("data/face2.jpg"); // loads image from file face2.jpg in folder data
  troll = loadImage("data/troll.jpg"); // loads image from file troll.jpg in folder data.
  xb=x=width/2; yb=y=height/2; // must be executed after size() to know values of width...
  for (int i = 0; i < trailX.length; i++) { // initialize the points to start from the center.
    trailX[i] = 300;
    trailY[i] = 300;
    newTrailX[i] = 300;
    newtrailY[i] = 300;
  }
}
//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  pen(black,3); // sets stroke color (to balck) and width (to 3 pixels)
  
  stroke(green); line(xb,yb,mouseX,mouseY);  // show line from base to mouse

  if (mousePressed) {fill(white); stroke(green); showDisk(mouseX,mouseY-4,12);} // paints a red disk filled with white if mouse pressed
  if (keyPressed) {fill(black); text(key,mouseX-2,mouseY); } // writes the character of key if still pressed
  if (!mousePressed && !keyPressed) scribeMouseCoordinates(); // writes current mouse coordinates if nothing pressed
  
  if(animating) {
    x+=vx; y+=vy; // move the blue point by its current velocity
    if(y<0) {y=-y; vy=-vy; } // collision with the ceiling
    if(y>height) {y=height*2-y; vy=-vy; } // collision with the floor
    if(x<0) {x=-x; vx=-vx; } // collision with the left wall
    if(x>width) {x=width*2-x; vx=-vx; } // collision with the right wall
    vy+= gravity; // add vertical gravity
    }
  
  noStroke(); fill(blue); showDisk(x,y,5); // show blue disk
  displayHeader();
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(filming && (animating || change)) saveFrame("FRAMES/"+nf(frameCounter++,4)+".tif");  
  change=false; // to avoid capturing frames when nothing happens
  // make sure that animating is set to true at the beginning of an animation and to false at the end
  
    if(mode2){
      drag(x,y); // Mode 2
    }
    
    else if (mode1) {
      push(x,y); // Mode 1
    }
    
    else if (mode3) {
      mode3(x, y); // Mode 3
      
    }
    else if (mode4) {
      mode3(x, y); // Same as mode 3. The extra effect is in the show() method.
    }
    
    else if (mode5) {
      
      mode5(x, y); // Mode 5 ("High" mode)
    }
    
    show();
    
  }  // end of draw()
  
//************************* mouse and key actions ****************************
void keyPressed() { // executed each time a key is pressed: the "key" variable contains the correspoinding char, 
  if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if(key=='!') snapPicture(); // make a picture of the canvas
  if(key=='~') { filming=!filming; } // filming on/off capture frames into folder FRAMES
  if(key==' ') {xb=x=width/2; yb=y=height/2; vx=0; vy=0;} // reset the blue ball at the center of the screen
  if(key=='a') animating=true;  // quit application
  if(key=='Q') exit();  // quit application
  if(key=='1') {mode1 = true; mode2 = false; mode3 = false; mode4 = false; mode5 = false; reset();} // switches to mode 1
  if(key=='2') {mode1 = false; mode2 = true; mode3 = false; mode4 = false; mode5 = false; reset();} // switches to mode 2
  if(key=='3') {mode1 = false; mode2 = false; mode3 = true; mode4 = false; mode5 = false; reset();} // switches to mode 3
  if(key=='4') {mode1 = false; mode2 = false; mode3 = false; mode4 = true; mode5 = false; reset();} // switches to mode 4
  if(key=='5') {mode1 = false; mode2 = false; mode3 = false; mode4 = false; mode5 = true; animating=true; gravity=5; vy = 20; vx = 20;} // switches to mode 5

  change=true;
  }

void keyReleased() { // executed each time a key is released
  if(key=='b') {xb=mouseX; yb=mouseY;}
  if(key=='a') animating=false;  // quit application
  change=true;
  }

void mouseDragged() { // executed when mouse is pressed and moved
  if(!keyPressed || key!='y') x+=mouseX-pmouseX; // pressing 'y' locks the motion to vertical displacements
  if(!keyPressed || key!='x') y+=mouseY-pmouseY;
  change=true;
  }

void mouseMoved() { // when mouse is moved
  change=true;
  }
  
void mousePressed() { // when mouse key is pressed 
  change=true;
  }
  
void mouseReleased() { // when mouse key is released 
  vx=mouseX-pmouseX; vy=mouseY-pmouseY; // sets the velocity of the blue dot to the last mouse motion (unreliable)
  change=true;
  }
  
//*************** text drawn on the canvas for name, title and help  *******************
String title ="CS3451, Fall 2014, Project 01: 'Blue Point'", name ="Bo Chen && Shen Yang!!!", // enter project number and your name
       menu="?:(show/hide) help, !:snap picture, ~:(start/stop) recording frames for movie, Q:quit",
       guide="Press&drag mouse to move dot. 'x', 'y' restrict motion",
       toogle="Press 1, 2, 3, 4, 5 to switch between modes"; // help info
       





