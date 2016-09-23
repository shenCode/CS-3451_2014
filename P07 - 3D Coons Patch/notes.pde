/*

3451 Project notes:

Goal: Replace th ecyan surface by an animated Coons patch defined by 
the 4 bounding curves (each one *interplating* 4 consecutive points of the polyloops).

Start with the 3D visualization and polyloop editor code provided here. 
It supports editing vertices in 3D and drawing a polyloop.
 

Functionality of the code provided:
We show two polyloops, P and Q
User operates on P
‘e’ swaps them, ‘q’ changes Q to be a copy of P, ‘p’ does the reverse
Pressing ‘x’, ‘z’, ‘d’ selects the vertex of P that has the closest screen projection to the mouse
Pressing ‘d’ deletes the selected vertex
Dragging the mouse while ‘x’ is pressed moves the selected vertex of P in X and Y
Dragging the mouse while ‘z’ is pressed moves the selected vertex of P in Z
Using ‘X’ or ‘Z’ instead, translates all vertices of P similarly
‘0’ snaps all vertices of P to the floor (z=0)
Dragging the mouse moves the black insert point in X and Y
Its closest projection on P is shown as a translucent sphere
Dragging the mouse while holding SHIFT moves the black insert point on in Z
Pressing ‘i’ inserts a new vertex in P at the closest projection of the black point
Holding SPACE down and moving the mouse (not pressed) rotates the view
Holding ‘f’ down and dragging the mouse (pressed) translates the scene in X and Y
Holding ‘F’ down and dragging the mouse (pressed) translates the scene in Z
Pressing ‘_’ toggles the display of the greound (yellow square) and the global frame
Pressing ‘]’ toggles the display of the thick green rods along  P and red rods along Q
Pressing ‘w’ saves P to file. Pressing ‘W’ saves both P and Q
Pressing ‘l’ (or ‘L’) loads the saved files into P (or into P and Q)

Implementation:
Ih the tab Geometry3D:

Setup loads P and Q from files.

Draw controls the viewing transformation (angle and focus point F).
If showFloor, it shows the ground and the shadows of P 
It shows the black insert point
It computes the screen projections I, J, K of the basis vectors (see PICK section at end of pv3D)
  These are used to interpret mouse movements in the model frame
It always compute pp as the ID in P of the vertex closest to the mouse

Create a function 





that returns a point on the Coons patch for parameters (u,v) assuming that the 4 curves that define it
are each interpolating 4 consecutive points of the polyloop P as shown below.
0 1 2 3 
11    4
10    5
9 8 7 6
This takes 7 lines of code (including the Neville interpolation code).

Then write 2 functions: 
void drawBorders(pt[] P, , float e){   }
that draws the border edges using sampling of e in parameter space (so here about 100 points)

void shadeSurface(pt[] P, float e){ }
that draws quads on the Coons patch. Here is my implementation of it:

void shadeSurface(pt[] P, float e){ 
  for(float s=0; s<1.001-e; s+=e) for(float t=0; t<1.001-e; t+=e) 
  {beginShape(); v(coons(P,s,t)); v(coons(P,s+e,t)); v(coons(P,s+e,t+e)); v(coons(P,s,t+e)); endShape(CLOSE);}
  }


*/
