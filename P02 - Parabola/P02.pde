/**************************** HEADER ****************************
 LecturesInGraphics: Template for Processing sketches in 2D
 Template author: Jarek ROSSIGNAC
 Class: CS3451 Fall 2014
 Student: Shen Yang
 Project number: P02
 Project title: Predicting the path
 Date of submission: 9/3/2014
*****************************************************************/


//**************************** global variables ****************************
float x, y; // coordinates of blue point controlled by the user
float vx=1, vy=0; // velocities
float xb, yb; // coordinates of base point, recorded as mouse location when 'b' is released
float gravity = 3;

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(600, 600);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/face.jpg"); // loads image from file face2.jpg in folder data
  troll = loadImage("data/troll.jpg"); // loads image from file troll.jpg in folder data.
  xb=x=width/2; yb=y=height/2; // must be executed after size() to know values of width...
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
  
      drag(x,y);

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
String title ="CS3451, Fall 2014, Project 02: 'Predicting the path'", name ="Shen Yang!!!", // enter project number and your name
       menu="?:(show/hide) help, !:snap picture, ~:(start/stop) recording frames for movie, Q:quit",
       guide="Press&drag mouse to move dot. 'x', 'y' restrict motion",
       toogle="Press 1, 2, 3, 4, 5 to switch between modes"; // help info
