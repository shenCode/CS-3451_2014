boolean showHelpText=true;
  void showHelp() {
    fill(yellow,50); rect(0,0,height,height); pushMatrix(); translate(20,20); fill(0);
        text("                    MESH VIEWER written by Jarek Rossignac in June 2006, updated in February 2008",0,0); translate(0,20);
        translate(0,20);
        text("Click in this window to start. Press SPACE at any time to show/hide this help text",0,0); translate(0,20);
        text("'k:action' means press key 'k' to perform the 'action' ",0,0); translate(0,20);
        text("'*k:action' means click(&drag) the mouse while holding the key 'k' to perform 'action' ",0,0); translate(0,20);
        text("VIEW: *:rotate, *z:zoom, *v:pan, Z:home, j:jump, J:jumping(on/off)",0,0); translate(0,20);
        text("CORNER: *.:select, p:prev, n:next, o:opposite, s:swing, u/t:unswing, l:left, r:right",0,0); translate(0,20);
        text("VERTEX: V:vertices(show/hide), N:normals(show/hide), *m:move ",0,0); translate(0,20);
        text("EDGE: E:edges(show/hide), f:flip, F:flip(allLonger), C:findShortest c:collapse, L:collapse(shortest)",0,0); translate(0,20);
        text("TRIANGLE: T:triangles(show/hide), *d_elete(hide/show)",0,0); translate(0,20);
        text("MESH: R:refine, S:smooth, H:heal, M:mend(fillHoles)",0,0); translate(0,20);
        text("COMPRESS: b:begin, a:advance(oneTriangle), K:compress(mesh), B:show(triangleColors)",0,0); translate(0,20);
        text("DISTANCE: D:distance(how/hide) <:smaller, >:larger, 0:zero, I:isolation, P:path(between selections) ",0,0); translate(0,20);
        text("FILES: 'g' next file. 'G' read model from file, 'A' archive model.",0,0); translate(0,20);
        text("A:archiveModel, X:snapPicture , w:writeCorner",0,0); translate(0,20);
        text("PROJECT: W:showLace,   ",0,0); translate(0,20);
 
     popMatrix(); noFill();
        }
void keys() {
  if (key==' ') {showHelpText=!showHelpText;};
  if (key=='<') {maxr--; if (maxr<1) maxr=1; M.computeDistance(maxr);};
  if (key=='>') {maxr++; M.computeDistance(maxr);};
  if (key=='.') {C.setMark(); M.hitTriangle();/* C.F.setToPoint(mark); C.pullE(); C.pose(); */ M.writeCorner();};
  if (key=='0') {maxr=0; M.computeDistance(maxr);};
  if (key=='a') {M.EBmove(); println("advanced edgebreaker to the next triangle");};
  if (key=='b') {M.EBinit(); println("anchored edgebreaker ");}; // init edgebreaker                  
  if (key=='c') {M.collapse(); M.left();};  // decimate one vertex by collapsing edge opposite to C
  if (key=='d') {C.setMark(); M.hitTriangle();  M.visible[M.t(M.c)]=!M.visible[M.t(M.c)];};  // delete/undelete (show/hide) the triangle picked with mouse   
  if (key=='e') {};
  if (key=='f') {M.flip();};                 // flips edge opposite to c
  if (key=='g') {fni=(fni+1)%fniMax; println("Will read model "+fn[fni]);};
  if (key=='i') {};   
  if (key=='h') { }; 
  if (key=='j') {if (M.showEBrec) {M.EBjump();} C.jump(M); C.snapD(); C.pullE();}
  if (key=='k') {};  
  if (key=='l') {M.left(); if (jumps) C.jump(M);};
// if (key=='m') {C.setMark(); M.hitTriangle();};   // also used in updateView to move vertex
  if (key=='n') {M.next();};  
  if (key=='o') {M.opposite(); if (jumps) C.jump(M); };  
  if (key=='p') {M.previous();};  
  if (key=='q') {showRibbon = !showRibbon;};   
  if (key=='r') {M.right(); if (jumps) C.jump(M);}; 
  if (key=='s') {M.swing();};   // select current corner
  if (key=='t') {showQuad = !showQuad;};  
  if (key=='u') {M.unswing();};   
 // if (key=='v') {};  // used in updateView 
  if (key=='w') {showTraceCurve = !showTraceCurve;};  
  if (key=='x') {WeaveInvasion = !WeaveInvasion;};   
  if (key=='y') {flying = !flying;};   
//  if (key=='z') {};   // used in updateView

  if (key=='A') {M.saveMesh(); println("archive mesh to file");  };  
  if (key=='B') {M.showEB=!M.showEB; if(M.showEB) println("showing edgebreaker colors"); else println("not showing edgebreaker colors");}; 
  if (key=='C') {M.findShortestEdge(); if (jumps) C.jump(M);};  // collpases shortest edge
  if (key=='D') {M.showDistance=!M.showDistance; if(M.showDistance) {M.computeDistance(maxr); println("showing distance");} else println("not showing distance");}; 
  if (key=='E') {M.showEdges=!M.showEdges; if(M.showEdges) println("showing wires (edges) "); else println("not showing wires (edges)"); };  
  if (key=='F') {M.flipWhenLonger(); println("flipped edges when this would shorten them");}; 
  if (key=='G') {println("loading fn["+fni+"]: "+fn[fni]); M.loadMesh();  M.init(); initView(M); M.step=0; println("Loaded a model");};  
  if (key=='H') {M.excludeInvisibleTriangles(); M.compactVO(); M.compactV(); M.computeO();  println("healed mesh by removing deleted triangles and compacting"); }; 
  if (key=='I') {M.computeIsolation(); println("Computed isolation"); }; 
  if (key=='J') {jumps=!jumps;  if(jumps) println("will track corner c automatically"); else println("will not track corner c automatically"); }; 
  if (key=='K') {M.firstCorner=M.c; M.EBcompress(M.firstCorner); M.showEB=true; println("Compressed");};  // run EdgeBreaker
  if (key=='L') {M.findShortestEdge(); M.collapse(); M.left();}; 
  if (key=='M') {M.fanHoles();  println("mended holes by filling them with fans");   }; 
  if (key=='N') {M.showNormals=!M.showNormals; if(M.showNormals) println("showing normals"); else println("not showing normals"); };  
  if (key=='O') { }; 
  if (key=='P') {M.computePath(); M.showDistance=true; println("showing path"); println("not showing path"); };
  if (key=='Q') { }; 
  if (key=='R') {M.splitEdges(); M.bulge(); M.splitTriangles(); M.init(); print("Refined the mesh");};   // refine mesh
  if (key=='S') {M.computeLaplaceVectors(); M.tuck(0.6); M.computeLaplaceVectors(); M.tuck(-0.6); println("Smoothed the mesh");};  
  if (key=='T') {M.showTriangles=!M.showTriangles; if(M.showTriangles) println("showing triangles"); else println("not showing triangles"); }; 
  if (key=='U') {}; 
  if (key=='V') {M.showVertices=!M.showVertices; if(M.showVertices) println("showing vertices"); else println("not showing vertices"); };  
  if (key=='W') {showLace=!showLace;};  
  if (key=='X') {String S="mesh"+"-####.tif"; saveFrame(S); println("saved a picture");};   ;
  if (key=='Y') {}; 
  if (key=='Z') {C.F.setToPoint(Cbox); C.D=Rbox*2; C.U.setTo(0,1,0); C.E.setToPoint(C.F); C.E.addVec(new vec(0,0,1)); C.pullE(); C.pose(); println("resert view"); }; 

  if (keyCode==LEFT) {M.left(); M.right(); M.left(); if (jumps) {C.jump(M);};};
  if (keyCode==RIGHT) {M.right(); M.left(); M.right(); if (jumps) {C.jump(M);};};
  if (keyCode==DOWN) {M.back(); M.left(); M.right(); M.right(); M.left(); M.back(); if (jumps) {C.jump(M);}; };
  if (keyCode==UP) {M.left(); M.right(); M.right(); M.left(); if (jumps) {C.jump(M);};};
  }
  
void updateView() {
  if (keyCode==SHIFT) {C.Pan(); C.pullE(); };
  if (keyCode==CONTROL) {C.turn(); C.pullE(); };  
  if (key=='z') {C.pose(); C.zoom(); C.pullE(); };
   if (key=='1') {C.pose(); C.fly(1.0); C.pullE(); };  
   if (key=='2') {C.pose(); C.Pan(); C.pullE(); };
   if (key=='3') {C.pose(); C.fly(-1.0); C.pullE();  };
   if (key=='v') {C.pose(); C.Turn(); C.pullE(); };
   if (key=='5') {C.pan(); C.pullE(); }; 
   if (key=='m') {M.move(); M.resetNormals();}; 
  }

pt Mouse = new pt(0,0,0);                 // current mouse position
float xr, yr = 0;                         // mouse coordinates relative to center of window
int px=0, py=0;                           // coordinats of mouse when it was last pressed
