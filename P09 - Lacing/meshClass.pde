// GLOBAL VARIABLES
int showSkeletOnly=1;
int rings=1;                               // number of rings for colorcoding
int r=10;                                // radius of spheres for displaying vertices
float w=10;  // width of ribbon
boolean showNormals=false, showVertices=false, showEdges=false, showTriangles=true,  showSelectedTriangle=true, showLabels=false, showPath=false;  // flags for rendering
boolean showSkeleton=true, showSelectedLake=true, showOtherLakes=true, showDistance=false, showEB=false, showEBrec=false, showClusters=true, showLace=false, showTraceCurve = false;
Mesh M = new Mesh();     // creates a default triangle mesh
boolean flying = false, alternate=true, showQuad = false, showRibbon = false, WeaveInvasion = false;
int size = 50, weave = -1;
int laceCount = 0;
int flyCount = 1;
//========================== class MESH ===============================
class Mesh {

//  ==================================== INIT, CREATE, COPY ====================================
 Mesh() {}
 void declare() {
   for (int i=0; i<maxnv; i++) {G[i]=new pt(0,0,0); Nv[i]=new vec(0,0,0);};   // init vertices and normals
   for (int i=0; i<maxnt; i++) {Nt[i]=new vec(0,0,0);  };       // init triangle normals and skeleton lab els
   }
 void makeGrid (int w) { // make a 2D grid of vertices
  for (int i=0; i<w; i++) {for (int j=0; j<w; j++) { G[w*i+j].setTo(height*.8*j/(w-1)+height/10,height*.8*i/(w-1)+height/10,0);}}    
  for (int i=0; i<w-1; i++) {for (int j=0; j<w-1; j++) {                  // define the triangles for the grid
    V[(i*(w-1)+j)*6]=i*w+j;       V[(i*(w-1)+j)*6+2]=(i+1)*w+j;       V[(i*(w-1)+j)*6+1]=(i+1)*w+j+1;
    V[(i*(w-1)+j)*6+3]=i*w+j;     V[(i*(w-1)+j)*6+5]=(i+1)*w+j+1;     V[(i*(w-1)+j)*6+4]=i*w+j+1;}; };
  nv = w*w;
  nt = 2*(w-1)*(w-1); 
  nc=3*nt;
  }
 void init() { 
   for (int i=0; i<maxnt; i++) {Nt[i]=new vec(0,0,0); visible[i]=true;};  
   computeO(); 
   computeValence(); 
   resetNormals();
   c=0; sc=0;  
  }
 void resetNormals() {
   computeTriNormals(); 
   computeVertexNormals(); 
   };

  // ============================================= DISPLAY =======================================
pt Cbox = new pt(width/2,height/2,0);                   // mini-max box center
float Rbox=1000;                                        // Radius of enclosing ball
boolean showEdges=false;
boolean showDistance=false;
boolean showNormals=false;
boolean showPath=false;
boolean showVertices=false;
boolean showEBrec=false;
boolean showTriangles=true;
void computeBox() {
  pt Lbox =  G[0].make();  pt Hbox =  G[0].make();
  for (int i=1; i<nv; i++) { 
    Lbox.x=min(Lbox.x,G[i].x); Lbox.y=min(Lbox.y,G[i].y); Lbox.z=min(Lbox.z,G[i].z);
    Hbox.x=max(Hbox.x,G[i].x); Hbox.y=max(Hbox.y,G[i].y); Hbox.z=max(Hbox.z,G[i].z); 
    };
  Cbox.setToPoint(midPt(Lbox,Hbox));  Rbox=Cbox.disTo(Hbox);
//  println("Box r="+Rbox); print("C="); Cbox.write(); print("L="); Lbox.write(); print("H="); Hbox.write();
  };
pt cg(int c) {pt cPt = midPt(g(c),midPt(g(c),triCenter(t(c))));  return(cPt); };   // computes point at corner
pt ccg(int c) {pt cPt = midPt(triCenter(t(c)),midPt(g(c),triCenter(t(c))));  return(cPt); };   // computes point at corner
void showCorner(int c, int r) {pt cPt = midPt(g(c),midPt(g(c),triCenter(t(c))));  cPt.show(r); };   // renders corner c as small ball
void showCornerAndNormal(int c, int r) {pt cPt = midPt(g(c),midPt(g(c),triCenter(t(c))));  noStroke(); cPt.show(r); 
                     stroke(magenta); vec N = Nt[t(c)].make(); N.makeUnit();  N.mul(10*r);  N.show(cPt);};   // renders corner c as small ball
void shade(int i) {if(visible[i]) { beginShape(TRIANGLES); G[V[3*i]].vert(); G[V[3*i+1]].vert(); G[V[3*i+2]].vert(); endShape(); };}; // shade tris
void showTriNormals() {vec N= new vec(0,0,0); for (int i=0; i<nt; i++) { N.setToVec(Nt[i]); N.makeUnit();  N.mul(5*r);  N.show(triCenter(i)); };  };
void showVertexNormals() {vec N= new vec(0,0,0); for (int i=0; i<nv; i++) {N.setToVec(Nv[i]); N.makeUnit(); N.mul(5*r);  N.show(G[i]); };  };

void show() {
  int col=60;
  noSmooth(); noStroke();
  // Project: showLace***** 
   if(showLace) {
     if (showEdges) {stroke(dblue); for(int i=0; i<nc; i++) if(visible[t(i)]) drawEdge(i); stroke(magenta); showBorder(); };  
     showLacing(w);  // at bottom of class
     if(flying) flyThrough();
     if(WeaveInvasion) WeaveInvasion();
     return;
     }
   if(showRibbon) {
     if (showEdges) {stroke(dblue); for(int i=0; i<nc; i++) if(visible[t(i)]) drawEdge(i); stroke(magenta); showBorder(); };  
     showRibbon(); return;
   }
   if(showQuad)  {
     if (showEdges) {stroke(dblue); for(int i=0; i<nc; i++) if(visible[t(i)]) drawEdge(i); stroke(magenta); showBorder(); };  
     showRibbon();  return;
   }
  if(showTraceCurve){
     if (showEdges) {stroke(dblue); for(int i=0; i<nc; i++) if(visible[t(i)]) drawEdge(i); stroke(magenta); showBorder(); };  
     showTraceCurve();  return;   
    }
   
   
   if(showDistance) for(int t=0; t<nt; t++) {if(Mt[t]==0) fill(10,255,255); else fill(60,120,(rings-Mt[t])*120/rings); shade(t);};  
   if(showEB&&!showDistance) {
      for(int t=0; t<nt; t++) {fill(cyan);
         if (triangleSymbol[t]=='w') {fill(white);};
         if (triangleSymbol[t]=='B') {fill(black);};
         if (triangleSymbol[t]=='C') {fill(yellow);};
         if (triangleSymbol[t]=='L') {fill(blue);};
         if (triangleSymbol[t]=='E') {fill(magenta);};
         if (triangleSymbol[t]=='R') {fill(orange);};
         if (triangleSymbol[t]=='S') {fill(red);};
         shade(t); 
         }
      };  
  if(showTriangles)  if(!showEB&&!showDistance) {fill(cyan); for(int t=0; t<nt; t++)  shade(t); noFill();};  
  smooth();
  if (showEdges) {stroke(dblue); for(int i=0; i<nc; i++) if(visible[t(i)]) drawEdge(i); };  
  stroke(red); showBorder();
  if (showVertices) {noStroke(); noSmooth();fill(blue); for (int v=0; v<nv; v++)  G[v].show(r); noFill();};
  if (showLabels) { fill(black); for (int i=0; i<nv; i++) {G[i].label(str(i),labelD); }; };
  if (showNormals) {stroke(blue); showTriNormals(); stroke(magenta); showVertexNormals(); };                // show triangle normals
  if (showSelectedTriangle) {
    noStroke(); fill(green); shade(t(c)); 
    fill(blue); stroke(dblue); showCornerAndNormal(c,r);  fill(cyan); noStroke(); showCornerAndNormal(prevc,r);  
    }; 
  fill(dred); mark.show(r); // stroke(red); line(eye.x,eye.y,eye.z,mark.x,mark.y,mark.z);  
  }

//  ==========================================================  VERTICES ===========================================
 int maxnv = 20000;                         //  max number of vertices
 int nv = 0;                              // current  number of vertices
 pt[] G = new pt [maxnv];                   // geometry table (vertices)
 vec[] Nv = new vec [maxnv];                 // vertex normals or laplace vectors
 int[] Mv = new int[maxnv];                  // vertex markers
 int [] Valence = new int [maxnv];          // vertex valence (count of incident triangles)
 boolean [] Border = new boolean [maxnv];   // vertex is border
 boolean [] VisitedV = new boolean [maxnv];  // vertex visited
void computeVertexNormals() {  // computes the vertex normals as sums of the normal vectors of incident tirangles scaled by area/2
  for (int i=0; i<nv; i++) {Nv[i].setTo(0,0,0);};  // resets the valences to 0
  for (int i=0; i<3*nt; i++) {Nv[v(i)].add(Nt[t(i)]);};
  for (int i=0; i<nv; i++) {Nv[i].makeUnit();}; 
  };
int addVertex(pt P) { G[nv].setTo(P); nv++; return nv-1;};
int addVertex(float x, float y, float z) { G[nv].x=x; G[nv].y=y; G[nv].z=z; nv++; return nv-1;};
void move() {g().addScaledVec(pmouseY-mouseY,N()); }
//  ==========================================================  EDGES ===========================================
void findShortestEdge() {  // assumes manifold
  float md=d(g(p(c)),g(n(c))); int ma=c;
  for (int a=0; a<nc; a++) if (vis(a)&&(d(g(p(a)),g(n(a)))<md)) {ma=a; md=d(g(p(a)),g(n(a)));}; 
  c=ma;
  } 
void drawEdge(int c) {line(g(p(c)).x,g(p(c)).y,g(p(c)).z,g(n(c)).x,g(n(c)).y,g(n(c)).z); };  // draws edge of t(c) opposite to corner c
void showBorder() {for (int i=0; i<nc; i++) {if (visible[t(i)]&&b(i)) {drawEdge(i);}; }; };         // draws all border edges

//  ==========================================================  TRIANGLES ===========================================
 int maxnt = maxnv*2;                       // max number of triangles
 int nt = 0;                   // current and max number of triangles
 vec[] Nt = new vec [maxnt];                // triangles normals
 boolean[] visible = new boolean[maxnt];    // set if triangle visible
 int[] Mt = new int[maxnt];                 // triangle markers for distance and other things   
 boolean [] VisitedT = new boolean [maxnt];  // triangle visited
pt triCenter(int i) {return(triCenterFromPts( G[V[3*i]], G[V[3*i+1]], G[V[3*i+2]] )); };  pt triCenter() {return triCenter(t());}  // computes center of triangle t(i) 
vec triNormal(int i) { return(triNormalFromPts(G[V[3*i]], G[V[3*i+1]], G[V[3*i+2]])); };  vec triNormal() {return triNormal(t());} // computes triangle t(i) normal * area / 2
void computeTriNormals() {for (int i=0; i<nt; i++) {Nt[i].setToVec(triNormal(i)); }; };             // caches normals of all tirangles
void writeTri (int i) {println("T"+i+": V = ("+V[3*i]+":"+v(o(3*i))+","+V[3*i+1]+":"+v(o(3*i+1))+","+V[3*i+2]+":"+v(o(3*i+2))+")"); };
void hitTriangle() {
   prevc=c;       // save for geodesic 
   float smallestDepth=10000000;
  boolean hit=false;
  for (int t=0; t<nt; t++) {
    if (rayHitTri(eye,mark,g(3*t),g(3*t+1),g(3*t+2))) {hit=true;
      float depth = rayDistTriPlane(eye,mark,g(3*t),g(3*t+1),g(3*t+2));
      if ((depth>0)&&(depth<smallestDepth)) {smallestDepth=depth;  c=3*t;};
      }; 
    };
  if (hit) {
    pt X = eye.make(); X.addScaledVec(smallestDepth,eye.vecTo(mark));
    mark.setToPoint(X);
    float distance=X.disTo(g(c));
    int b=c;
    if (X.disTo(g(n(c)))<distance) {b=n(c); distance=X.disTo(g(b)); };
    if (X.disTo(g(p(c)))<distance) {b=p(c);};
    c=b;
    println("c="+c+", pc="+prevc+", t(pc)="+t(prevc));
    };
  }
void addTriangle(int i, int j, int k) {V[nc++]=i; V[nc++]=j; V[nc++]=k; nt++;}
// ============================================= CORNER OPERATORS =======================================
 int nc = nt*3;                             // current number of corners (3 per triangle)
 int c = 0;                                 // current corner shown in image and manipulated with keys: n, p, o, l, r
 int sc=0;                                  // saved value of c
 int[] V = new int [3*maxnt];               // V table (triangle/vertex indices)
 int[] O = new int [3*maxnt];               // O table (opposite corner indices)
 int[] W = new int [3*maxnt];               // mid-edge vertex indices for subdivision (associated with corner opposite to edge)
 int[] Tc = new int[3*maxnt];               // corner type

int t (int c) {int r=int(c/3); return(r);};            int t() {return t(c);}
int n (int c) {int r=3*int(c/3)+(c+1)%3; return(r);};  int n() {return n(c);}
int p (int c) {int r=3*int(c/3)+(c+2)%3; return(r);};  int p() {return p(c);}
int v (int c) {return(V[c]);};                         int v() {return v(c);}
int o (int c) {return(O[c]);};                         int o() {return o(c);}
int s (int c) {return(n(O[n(c)]));};                   int s() {return s(c);}
int u (int c) {return(p(O[p(c)]));};                   int u() {return u(c);}
int l (int c) {return(o(n(c)));};                      int l() {return l(c);}
int r (int c) {return(o(p(c)));};                      int r() {return r(c);}
pt g (int c) {return(G[V[c]]);}; pt g() {return g(c);}            // shortcut to get the point of the vertex v(c) of corner c
vec N (int c) {return(Nv[V[c]]);}; vec N() {return N(c);}            // shortcut to get the point of the vertex v(c) of corner c
int w (int c) {return(W[c]);};               // temporary indices to mid-edge vertices associated with corners during subdivision
boolean nb(int c) {return O[c]!=c ;};  boolean nb() {return nb(c);}     // not border
boolean b(int c) {return O[c]==c ;};              // border: returns true if corner has no opposite
boolean vis(int c) {return visible[t(c)]; };   // true if tiangle of c is visible
  
void previous() {c=p();};
void next() {c=n();};
void opposite() {if(nb()) {c=o(c);};};
void swing() {c=s(c);};
void left() {next(); opposite();};
void right() {previous(); opposite();};
void back() {opposite();};
void unswing() {c=u(c); };

void writeCorner (int c) {println("c="+c+", n="+n(c)+", p="+p(c)+", o="+o(c)+", v="+v(c)+", t="+t(c)+", EB symbol="+triangleSymbol[t(c)]+"."+", nt="+nt+", nv="+nv ); }; 
void writeCorner () {writeCorner (c);}
void writeCorners () {for (int c=0; c<nc; c++) {println("T["+c+"]="+t(c)+", visible="+visible[t(c)]+", v="+v(c)+",  o="+o(c));};}

// ============================================= O TABLE CONSTRUCTION =========================================
void computeOnaive() {                         // sets the O table from the V table, assumes consistent orientation of triangles
  for (int i=0; i<3*nt; i++) {O[i]=i;};  // init O table to itself: has no opposite (i.e. is a border corner)
  for (int i=0; i<3*nt; i++) {  for (int j=i+1; j<3*nt; j++) {       // for each corner i, for each other corner j
      if( (v(n(i))==v(p(j))) && (v(p(i))==v(n(j))) ) {O[i]=j; O[j]=i;};};}; // make i and j opposite if they match         
  };

void computeO() { 
  int nIC [] = new int [maxnv];                   // number of incident corners
  int maxValence=0;
  for (int c=0; c<nc; c++) {O[c]=c;};  // init O table to c: has no opposite (i.e. is a border corner)
  for (int v=0; v<nv; v++) {nIC[v]=0; };
  for (int c=0; c<nc; c++) {nIC[v(c)]++;}
  for (int v=0; v<nv; v++) {if(nIC[v]>maxValence) {maxValence=nIC[v]; };};
  println(" Max valence = "+maxValence+". ");
  int IC [][] = new int [maxnv][maxValence];                   // incident corners
  for (int v=0; v<nv; v++) {nIC[v]=0; };
  for (int c=0; c<nc; c++) {IC[v(c)][nIC[v(c)]++]=c;}
  for (int c=0; c<nc; c++) {
    for (int i=0; i<nIC[v(p(c))]; i++) {
      int a = IC[v(p(c))][i];
      for (int j=0; j<nIC[v(n(c))]; j++) {
         int b = IC[v(n(c))][j];
         if ((b==n(a))&&(c!=n(b))) {O[c]=n(b); O[n(b)]=c; };
         };
      };
    };
  }

// ============================================================= ARCHIVAL ============================================================
 boolean flipOrientation=false;            // if set, save will flip all triangles

void saveMesh() {
  String [] inppts = new String [nv+1+nt+1];
  int s=0;
  inppts[s++]=str(nv);
  for (int i=0; i<nv; i++) {inppts[s++]=str(G[i].x)+","+str(G[i].y)+","+str(G[i].z);};
  inppts[s++]=str(nt);
  if (flipOrientation) {for (int i=0; i<nt; i++) {inppts[s++]=str(V[3*i])+","+str(V[3*i+2])+","+str(V[3*i+1]);};}
    else {for (int i=0; i<nt; i++) {inppts[s++]=str(V[3*i])+","+str(V[3*i+1])+","+str(V[3*i+2]);};};
  saveStrings("mesh.vts",inppts);  println("saved on file");
  };

void loadMesh() {
  println("loading fn["+fni+"]: "+fn[fni]); 
  String [] ss = loadStrings(fn[fni]);
  String subpts;
  int s=0;   int comma1, comma2;   float x, y, z;   int a, b, c;
  nv = int(ss[s++]);
    print("nv="+nv);
    for(int k=0; k<nv; k++) {int i=k+s; 
      comma1=ss[i].indexOf(',');   
      x=float(ss[i].substring(0, comma1));
      String rest = ss[i].substring(comma1+1, ss[i].length());
      comma2=rest.indexOf(',');    y=float(rest.substring(0, comma2)); z=float(rest.substring(comma2+1, rest.length()));
      G[k].setTo(x,y,z);
    };
  s=nv+1;
  nt = int(ss[s]); nc=3*nt;
  println(", nt="+nt);
  s++;
  for(int k=0; k<nt; k++) {int i=k+s;
      comma1=ss[i].indexOf(',');   a=int(ss[i].substring(0, comma1));  
      String rest = ss[i].substring(comma1+1, ss[i].length()); comma2=rest.indexOf(',');  
      b=int(rest.substring(0, comma2)); c=int(rest.substring(comma2+1, rest.length()));
      V[3*k]=a;  V[3*k+1]=b;  V[3*k+2]=c;
    }
  };
  


//  ==========================================================  SIMPLIFICATION ===========================================

void flip() {flip(c);}
void flip(int c) {      // flip edge opposite to corner c
    V[n(o(c))]=v(c); V[n(c)]=v(o(c));
    int co=o(c); O[co]=r(c); O[r(c)]=co; O[c]=r(co); O[r(co)]=c; O[p(c)]=p(co); O[p(co)]=p(c);
  }
  
void flipWhenLonger() {  for (int c=0; c<3*nt; c++) {
  if (nb(c)) {if (g(n(c)).disTo(g(p(c)))>g(c).disTo(g(o(c)))) {flip(c);}; }; };
  } 


void collapse() {collapse(c);}
void collapse(int c) {                                   // collapse edge opposite to corner c, does not check anything !!! assumes manifold
   int b=n(c), oc=o(c), vpc=v(p(c));
   visible[t(c)]=false; visible[t(oc)]=false;
   for (int a=b; a!=p(oc); a=n(l(a))) V[a]=vpc;
   O[l(c)]=r(c); O[r(c)]=l(c);     O[l(oc)]=r(oc); O[r(oc)]=l(oc); 
  }

//  ==========================================================  HOLES ===========================================
pt holeCenter = new pt (0,0,0);
vec holeNormal = new vec(0,0,1);
pt  centerOfHole() {pt C=new pt(0,0,0); int nb=0; for (int i=0; i<nc; i++) {if (visible[t(i)]&&b(i)) {nb++; C.addPt(g(p(i)));}; }; C.mul(1./nb); return C;};         // draws all border edges
vec  normalOfHole(pt C) {vec N=new vec(0,0,0); for (int i=0; i<nc; i++) {if (visible[t(i)]&&b(i)) N.add(cross(C.vecTo(g(p(i))),C.vecTo(g(n(i))))); }; N.makeUnit(); return N;};         // draws all border edges
void excludeInvisibleTriangles () {for (int b=0; b<nc; b++) {if (!visible[t(o(b))]) {O[b]=b;};};}
void hole() {holeCenter.setTo(centerOfHole()); holeNormal.setTo(normalOfHole(holeCenter)); };
void fanHoles() {
  println("FANHOLES: nv="+nv +", nt="+nt +", nc="+nc );
  for (int t=0; t<nt; t++) {VisitedT[t]=false;};
  int lnt=nt;
  int L=0;
  for (int cc=0; cc<nc; cc++) {
   if (visible[t(cc)]&&(!VisitedT[t(cc)]) && (!nb(cc) )) {L++;
      print("<"); G[nv].setTo(0,0,0); int hl=fanHole(cc,L); G[nv].mul(1.0/float(hl)); nv++; println("> hl="+hl);
     };
   };
   for (int t=lnt; t<nt; t++) {visible[t]=true;};
   nc=3*nt;
   println("Filled "+L+" holes");
  }
  
int fanHole(int cc, int L) {
 int hl=0; int o=0;  int f=cc;
 print("."); VisitedT[t(f)]=true; hl++; o=3*nt; V[o]=nv; V[n(o)]=v(p(f)); V[p(o)]=v(n(f)); O[o]=f; O[f]=o; nt++; G[nv].addPt(g(p(f)));
 int lc=p(o); 
 f=n(f);  while(nb(f)) {f=n(o(f)); }; 
 while (f!=cc) {    
       print("."); VisitedT[t(f)]=true; hl++;  o=3*nt; V[o]=nv; V[n(o)]=v(p(f)); V[p(o)]=v(n(f)); O[o]=f; O[f]=o; nt++; G[nv].addPt(g(p(f)));
      O[n(o)]=lc; O[lc]=n(o); lc=p(o);
      f=n(f);  while(nb(f)&&(f!=cc)) {f=n(o(f)); }; 
      }; 
  O[lc]=n(o(cc)); O[n(o(cc))]=lc; c=lc;
  return(hl);
  }
  
void compactVO() {  
  println("COMPACT TRIANGLES: nv="+nv +", nt="+nt +", nc="+nc );
  int[] U = new int [nc];
  int lc=-1; for (int c=0; c<nc; c++) {if (visible[t(c)]) {U[c]=++lc; }; };
  for (int c=0; c<nc; c++) {if (nb(c)) {O[c]=U[o(c)];} else {O[c]=c;}; };
  int lt=0;
  for (int t=0; t<nt; t++) {
    if (visible[t]) {
      V[3*lt]=V[3*t]; V[3*lt+1]=V[3*t+1]; V[3*lt+2]=V[3*t+2]; 
      O[3*lt]=O[3*t]; O[3*lt+1]=O[3*t+1]; O[3*lt+2]=O[3*t+2]; 
       visible[lt]=true; 
      lt++;
      };
    };
nt=lt; nc=3*nt;    
  println("      ...  NOW: nv="+nv +", nt="+nt +", nc="+nc );
  }

void compactV() {  
  println("COMPACT VERTICES: nv="+nv +", nt="+nt +", nc="+nc );
  int[] U = new int [nv];
  boolean[] deleted = new boolean [nv];
  for (int v=0; v<nv; v++) {deleted[v]=true;};
  for (int c=0; c<nc; c++) {deleted[v(c)]=false;};
  int lv=-1; for (int v=0; v<nv; v++) {if (!deleted[v]) {U[v]=++lv; }; };
  for (int c=0; c<nc; c++) {V[c]=U[v(c)]; };
  lv=0;
  for (int v=0; v<nv; v++) {
    if (!deleted[v]) {G[lv].setToPoint(G[v]);  deleted[lv]=false; 
      lv++;
      };
    };
 nv=lv;
 println("      ...  NOW: nv="+nv +", nt="+nt +", nc="+nc );
  }

// =========================================== GEODESIC MEASURES, DISTANCES =============================
 boolean[] P = new boolean [3*maxnt];       // marker of corners in a path to parent triangle
 int[] Distance = new int[maxnt];           // triangle markers for distance fields 
 int[] SMt = new int[maxnt];                // sum of triangle markers for isolation
 int prevc = 0;                             // previously selected corner

void computeDistance(int maxr) {
  int tc=0;
  int r=1;
  for(int i=0; i<nt; i++) {Mt[i]=0;};  Mt[t(c)]=1; tc++;
  for(int i=0; i<nv; i++) {Mv[i]=0;};
  while ((tc<nt)&&(r<=maxr)) {
      for(int i=0; i<nc; i++) {if ((Mv[v(i)]==0)&&(Mt[t(i)]==r)) {Mv[v(i)]=r;};};
     for(int i=0; i<nc; i++) {if ((Mt[t(i)]==0)&&(Mv[v(i)]==r)) {Mt[t(i)]=r+1; tc++;};};
     r++;
     };
  rings=r;
  }
  
void computeIsolation() {
  println("Starting isolation computation for "+nt+" triangles");
  for(int i=0; i<nt; i++) {SMt[i]=0;}; 
  for(c=0; c<nc; c+=3) {println("  triangle "+t(c)+"/"+nt); computeDistance(1000); for(int j=0; j<nt; j++) {SMt[j]+=Mt[j];}; };
  int L=SMt[0], H=SMt[0];  for(int i=0; i<nt; i++) { H=max(H,SMt[i]); L=min(L,SMt[i]);}; if (H==L) {H++;};
  c=0; for(int i=0; i<nt; i++) {Mt[i]=(SMt[i]-L)*255/(H-L); if(Mt[i]>Mt[t(c)]) {c=3*i;};}; rings=255;
  for(int i=0; i<nv; i++) {Mv[i]=0;};  for(int i=0; i<nc; i++) {Mv[v(i)]=max(Mv[v(i)],Mt[t(i)]);};
  println("finished isolation");
  }
  
void computePath() {
  for(int i=0; i<nt; i++) {Mt[i]=0;}; Mt[t(prevc)]=1; // Mt[0]=1;
  for(int i=0; i<nc; i++) {P[i]=false;};
  int r=1;
  boolean searching=true;
  while (searching) {
     for(int i=0; i<nc; i++) {
       if (searching&&(Mt[t(i)]==0)&&(o(i)!=i)) {
         if(Mt[t(o(i))]==r) {
           Mt[t(i)]=r+1; 
           P[i]=true; 
           if(t(i)==t(c)){searching=false;};
           };
         };
       };
     r++;
     };
  for(int i=0; i<nt; i++) {Mt[i]=0;};
  rings=1;
  int b=c;
  int k=0;
   while (t(b)!=t(prevc)) {rings++;  
   if (P[b]) {b=o(b); print(".o");} else {if (P[p(b)]) {b=r(b);print(".r");} else {b=l(b);print(".l");};}; Mt[t(b)]=rings; };
  }

// ============================================================= SMOOTHING ============================================================
void computeValence() {      // caches valence of each vertex
  for (int i=0; i<nv; i++) {Nv[i].setTo(0,0,0); Valence[i]=0;};  // resets the valences to 0
  for (int i=0; i<nc; i++) {Valence[v(i)]++; };
  }

void computeLaplaceVectors() {  // computes the vertex normals as sums of the normal vectors of incident tirangles scaled by area/2
  computeValence();
  for (int i=0; i<3*nt; i++) {Nv[v(p(i))].add(g(p(i)).vecTo(g(n(i))));};
  for (int i=0; i<nv; i++) {Nv[i].div(Valence[i]);}; 
  };
  
void tuck(float s) {for (int i=0; i<nv; i++) {G[i].addScaledVec(s,Nv[i]);}; };  // displaces each vertex by a fraction s of its normal

// ============================================================= SUBDIVISION ============================================================
void splitEdges() {            // creates a new vertex for each edge and stores its ID in the W of the corner (and of its opposite if any)
  for (int i=0; i<3*nt; i++) {  // for each corner i
    if(b(i)) {G[nv]=midPt(g(n(i)),g(p(i))); W[i]=nv++;}
    else {if(i<o(i)) {G[nv]=midPt(g(n(i)),g(p(i))); W[o(i)]=nv; W[i]=nv++; }; };  // if this corner is the first to see the edge
    };
  };
  
void bulge() {              // tweaks the new mid-edge vertices according to the Butterfly mask
  for (int i=0; i<3*nt; i++) {
    if((nb(i))&&(i<o(i))) {    // no tweak for mid-vertices of border edges
     if (nb(p(i))&&nb(n(i))&&nb(p(o(i)))&&nb(n(o(i))))
      {G[W[i]].addScaledVec(0.25,midPt(midPt(g(l(i)),g(r(i))),midPt(g(l(o(i))),g(r(o(i))))).vecTo(midPt(g(i),g(o(i))))); };
      }; 
    };
  };
  
void splitTriangles() {    // splits each tirangle into 4
  for (int i=0; i<3*nt; i=i+3) {
    V[3*nt+i]=v(i); V[n(3*nt+i)]=w(p(i)); V[p(3*nt+i)]=w(n(i));
    V[6*nt+i]=v(n(i)); V[n(6*nt+i)]=w(i); V[p(6*nt+i)]=w(p(i));
    V[9*nt+i]=v(p(i)); V[n(9*nt+i)]=w(n(i)); V[p(9*nt+i)]=w(i);
    V[i]=w(i); V[n(i)]=w(n(i)); V[p(i)]=w(p(i));
    };
  nt=4*nt; nc=3*nt;
  };

// ============================================================= COMPRESSION ============================================================
 char[] triangleSymbol = new char[maxnt];
 char[] CLERS = new char[maxnt];
 int symbols=0;
 int stack[] = new int[10000];
 int stackHeight=1;
 int Ccount=0, Lcount=0, Ecount=0, Rcount=0, Scount=0;
 boolean EBisDone;
 int firstCorner=0; 
 boolean showEB=false;
 int step=1;                              // to do something step by step

void EBcompress(int c) {
 Ccount=0; Lcount=0; Ecount=0; Rcount=0; Scount=0; 
 resetStack(); 
 for (int v=0; v<nv; v++) {VisitedV[v]=false;};
 for (int t=0; t<nt; t++) {VisitedT[t]=false;};
 VisitedT[t(c)]=true; triangleSymbol[t(c)]='B'; VisitedV[v(c)]=true; VisitedV[v(n(c))]=true; VisitedV[v(p(c))]=true; c=r(c);
 symbols=0; 
 boolean EBisDone=false;
 while (!EBisDone) {
  VisitedT[t(c)]=true; 
  if (!VisitedV[v(c)]) {triangleSymbol[t(c)]='C'; Ccount++; CLERS[symbols++]=triangleSymbol[t(c)]; VisitedV[v(c)]=true; c=r(c); }
  else {
    if (VisitedT[t(r(c))]) {
        if (VisitedT[t(l(c))]) {triangleSymbol[t(c)]='E'; Ecount++; CLERS[symbols++]=triangleSymbol[t(c)]; c=stack[--stackHeight]; if (stackHeight==0) {EBisDone=true;};}
        else {triangleSymbol[t(c)]='R'; Rcount++; CLERS[symbols++]=triangleSymbol[t(c)]; c=l(c);};
       }
    else {
        if (VisitedT[t(l(c))]) {triangleSymbol[t(c)]='L'; Lcount++; CLERS[symbols++]=triangleSymbol[t(c)]; c=r(c);}
        else {triangleSymbol[t(c)]='S'; triangleSymbol[t(l(c))]='w'; Scount++; CLERS[symbols++]=triangleSymbol[t(c)]; stack[stackHeight++]=l(c); c=r(c);};
      };
    };
  }; 
  int total=Ccount+Lcount+Ecount+Rcount+Scount;
  println(nt+" triangles, "+total+" symbols: C="+Ccount+", L="+Lcount+", E="+Ecount+", R="+Rcount+", S="+Scount);
 }



int pop() {if (stackHeight==0){ println("Stack is empty"); stackHeight=1;}; return(stack[--stackHeight]);}
void push(int c) {stack[stackHeight++]=c; }
void resetStack() {stackHeight=1;};

void EBinit() {
   for (int v=0; v<nv; v++) {VisitedV[v]=false;};
   for (int t=0; t<nt; t++) {VisitedT[t]=false;};
   VisitedT[t(c)]=true; triangleSymbol[t(c)]='B'; VisitedV[v(c)]=true; VisitedV[v(n(c))]=true; VisitedV[v(p(c))]=true; c=r(c);
   symbols=0; EBisDone=false;
   }
   
void EBmove() {
 if (!EBisDone) {
  VisitedT[t(c)]=true; 
  if (!VisitedV[v(c)]) {triangleSymbol[t(c)]='C'; Ccount++; CLERS[symbols++]=triangleSymbol[t(c)]; VisitedV[v(c)]=true; c=r(c); }
  else {
    if (VisitedT[t(r(c))]) {
        if (VisitedT[t(l(c))]) {triangleSymbol[t(c)]='E'; Ecount++; CLERS[symbols++]=triangleSymbol[t(c)]; c=stack[--stackHeight]; if (stackHeight==0) {EBisDone=true;};}
        else {triangleSymbol[t(c)]='R'; Rcount++; CLERS[symbols++]=triangleSymbol[t(c)]; c=l(c);};
       }
    else {
        if (VisitedT[t(l(c))]) {triangleSymbol[t(c)]='L'; Lcount++; CLERS[symbols++]=triangleSymbol[t(c)]; c=r(c);}
        else {triangleSymbol[t(c)]='S'; triangleSymbol[t(l(c))]='w'; Scount++; CLERS[symbols++]=triangleSymbol[t(c)]; stack[stackHeight++]=l(c); c=r(c);};
      };
    };
   print(symbols+":"+CLERS[symbols-1]+" ");
  } else {print(".");};
 }
 
void EBjump() {
  int t=t(c);
  if (triangleSymbol[t]=='B') {c=r(c);};
  if (triangleSymbol[t]=='C') {c=r(c);};
  if (triangleSymbol[t]=='L') {c=r(c);};
  if (triangleSymbol[t]=='E') {c=pop();};
  if (triangleSymbol[t]=='R') {c=l(c);};
  if (triangleSymbol[t]=='S') {push(l(c)); c=r(c);};
  }

void EBshow(int c, pt nV, pt pV) {
  fill(yellow);
  int t=t(c);
  pt tV = g(c).make();
  if (triangleSymbol[t]=='B') {fill(200,200,200);tV.moveTowards(0.07,nV);};
  if (triangleSymbol[t]=='C') {fill(90,250,200); tV.moveTowards(0.07,nV);};
  if (triangleSymbol[t]=='L') {fill(20,250,250);};
  if (triangleSymbol[t]=='E') {fill(155,250,150); tV.moveTowards(0.05,pV); tV.moveTowards(0.05,nV);};
  if (triangleSymbol[t]=='R') {fill(127,250,200);};
  if (triangleSymbol[t]=='S') {fill(255,250,150); tV.moveTowards(0.05,pV); tV.moveTowards(0.05,nV);};
  beginShape(TRIANGLES);  nV.vert();   pV.vert();  tV.vert(); endShape(); 
  if (triangleSymbol[t]=='B') {EBshow(r(c),nV,tV);};
  if (triangleSymbol[t]=='C') {EBshow(r(c),nV,tV);};
  if (triangleSymbol[t]=='L') { EBshow(r(c),nV,tV);};
  if (triangleSymbol[t]=='E') { };
  if (triangleSymbol[t]=='R') { EBshow(l(c),tV,pV);};
  if (triangleSymbol[t]=='S') { EBshow(r(c),nV,tV); EBshow(l(c),tV,pV);};
  };

void EBprint(int c) {
   int t=t(c);
   print(triangleSymbol[t]); CLERS[symbols++]=triangleSymbol[t(c)]; 
  if (triangleSymbol[t]=='B') {EBprint(r(c));};
  if (triangleSymbol[t]=='C') {EBprint(r(c));};
  if (triangleSymbol[t]=='L') {EBprint(r(c));};
  if (triangleSymbol[t]=='E') { };
  if (triangleSymbol[t]=='R') {EBprint(l(c));};
  if (triangleSymbol[t]=='S') {EBprint(r(c)); EBprint(l(c));};
  };

void EBprintS(int pc) {
 int c=pc; 
 symbols=0;
 resetStack();
 boolean EBisDone=false;
 while (!EBisDone) {
   int t=t(c);
//   print(triangleSymbol[t]); 
   CLERS[symbols++]=triangleSymbol[t(c)]; 
  if (triangleSymbol[t]=='B') {c=r(c);};
  if (triangleSymbol[t]=='C') {c=r(c);};
  if (triangleSymbol[t]=='L') {c=r(c);};
  if (triangleSymbol[t]=='E') {c=pop(); if (stackHeight==0) {EBisDone=true;}};
  if (triangleSymbol[t]=='R') {c=l(c);};
  if (triangleSymbol[t]=='S') {push(r(c)); c=l(c);};
   };
 };

int leadingCS() { int r = 1; while (CLERS[r]=='C') {r++;};  return(r);};

void EBstats(int lCs) {
 int cc=0, cl=0, ce=0, cr=0, cs=0, ct=0; 
 int lc=0, ll=0, le=0, lr=0, ls=0, lt=0; 
 int ec=0, el=0, ee=0, er=0, es=0, et=0; 
 int rc=0, rl=0, re=0, rr=0, rs=0, rt=0; 
 int sc=0, sl=0, se=0, sr=0, ss=0, st=0; 
 char last='C';
  println("    The "+lCs+" leading Cs are not counted and replaced by an overhead of "+int(log2(lCs))+" bits");
 for (int i=lCs; i<symbols; i++) {
   char s=CLERS[i];    print(s);
   if (last=='C') {if(s=='C') {cc++;}; if(s=='L') {cl++;}; if(s=='E') {ce++;}; if(s=='R') {cr++;}; if(s=='S') {cs++;}; };
   if (last=='L') {if(s=='C') {lc++;}; if(s=='L') {ll++;}; if(s=='E') {le++;}; if(s=='R') {lr++;}; if(s=='S') {ls++;}; };
   if (last=='E') {if(s=='C') {ec++;}; if(s=='L') {el++;}; if(s=='E') {ee++;}; if(s=='R') {er++;}; if(s=='S') {es++;}; };
   if (last=='R') {if(s=='C') {rc++;}; if(s=='L') {rl++;}; if(s=='E') {re++;}; if(s=='R') {rr++;}; if(s=='S') {rs++;}; };
   if (last=='S') {if(s=='C') {sc++;}; if(s=='L') {sl++;}; if(s=='E') {se++;}; if(s=='R') {sr++;}; if(s=='S') {ss++;}; };
   last=s;
   };
  println();
  print("symbols reduced from "+symbols);  int rsymbols=symbols-lCs;  println(" to "+rsymbols);
  ct=cc+lc+ec+rc+sc;
  lt=cl+ll+el+rl+sl;
  et=ce+le+ee+re+se;
  rt=cr+lr+er+rr+sr;
  st=cs+ls+es+rs+ss;
  
  float Cf=float(ct)/rsymbols, Lf=float(lt)/rsymbols, Ef=float(et)/rsymbols, Rf=float(rt)/rsymbols, Sf=float(st)/rsymbols;
  float entropy = -( log2(Cf)*Cf + log2(Lf)*Lf + log2(Ef)*Ef + log2(Rf)*Rf + log2(Sf)*Sf ); 
   println("100*Frequencies: C="+nf(Cf*100,2,2)+", L="+nf(Lf*100,2,2)+", E="+nf(Ef*100,2,2)+", R="+nf(Rf*100,2,2)+", S="+nf(Sf*100,2,2));
   println("***   Entropy (over remaining symbols ) = "+nf(entropy,1,2));
  println();
  println("COUNTS for "+rsymbols+" CLERS symbols:");
  println("        COUNTS cc="+nf(cc,4)+",  lc="+nf(lc,4)+",  ec="+nf(ec,4)+",  rc="+nf(rc,4)+",  sc="+nf(sc,4)+" .c="+nf(ct,4)); 
  println("        COUNTS cl="+nf(cl,4)+",  ll="+nf(ll,4)+",  el="+nf(el,4)+",  rl="+nf(rl,4)+",  sl="+nf(sl,4)+" .l="+nf(lt,4)); 
  println("        COUNTS ce="+nf(ce,4)+",  le="+nf(le,4)+",  ee="+nf(ee,4)+",  re="+nf(re,4)+",  se="+nf(se,4)+" .e="+nf(et,4)); 
  println("        COUNTS cr="+nf(cr,4)+",  lr="+nf(lr,4)+",  er="+nf(er,4)+",  rr="+nf(rr,4)+",  sr="+nf(sr,4) +" .r="+nf(rt,4)); 
  println("        COUNTS cs="+nf(cs,4)+",  ls="+nf(ls,4)+",  es="+nf(es,4)+",  rs="+nf(rs,4)+",  ss="+nf(ss,4) +" .s="+nf(st,4)); 
  float cost = entropy*rsymbols;   float costWlcs = cost+int(log2(lCs));
  float e = cost/(symbols);   float eWlcs = costWlcs/(symbols); 
  println("***  Amortized over all symbols :");
  println("*** No-context:                 Entropy = "+nf(e,1,2)+" bpt. Total cost = "+nf(cost,6,2)+" bits");
  println("*** counting RLE of leading Cs: Entropy = "+nf(eWlcs,1,2)+" bpt. Total cost = "+nf(costWlcs,6,2)+" bits");

  println("Pairs frequencies:");
  println("        COUNTS cc="+nf(float(cc)/rsymbols,1,4)+",  lc="+nf(float(lc)/rsymbols,1,4)+",  ec="+nf(float(ec)/rsymbols,1,4)+",  rc="+nf(float(rc)/rsymbols,1,4)+",  sc="+nf(float(sc)/rsymbols,1,4)+" .c="+nf(float(ct)/rsymbols,1,4)); 
  println("        COUNTS cl="+nf(float(cl)/rsymbols,1,4)+",  ll="+nf(float(ll)/rsymbols,1,4)+",  el="+nf(float(el)/rsymbols,1,4)+",  rl="+nf(float(rl)/rsymbols,1,4)+",  sl="+nf(float(sl)/rsymbols,1,4)+" .l="+nf(float(lt)/rsymbols,1,4)); 
  println("        COUNTS ce="+nf(float(ce)/rsymbols,1,4)+",  le="+nf(float(le)/rsymbols,1,4)+",  ee="+nf(float(ee)/rsymbols,1,4)+",  re="+nf(float(re)/rsymbols,1,4)+",  se="+nf(float(se)/rsymbols,1,4)+" .e="+nf(float(et)/rsymbols,1,4)); 
  println("        COUNTS cr="+nf(float(cr)/rsymbols,1,4)+",  lr="+nf(float(lr)/rsymbols,1,4)+",  er="+nf(float(er)/rsymbols,1,4)+",  rr="+nf(float(rr)/rsymbols,1,4)+",  sr="+nf(float(sr)/rsymbols,1,4) +" .r="+nf(float(rt)/rsymbols,1,4)); 
  println("        COUNTS cs="+nf(float(cs)/rsymbols,1,4)+",  ls="+nf(float(ls)/rsymbols,1,4)+",  es="+nf(float(es)/rsymbols,1,4)+",  rs="+nf(float(rs)/rsymbols,1,4)+",  ss="+nf(float(ss)/rsymbols,1,4) +" .s="+nf(float(st)/rsymbols,1,4)); 


  ct=cc+cl+ce+cr+cs;
  lt=lc+ll+le+lr+ls;
  et=ec+el+ee+er+es;
  rt=rc+rl+re+rr+rs;
  st=sc+sl+se+sr+ss;

  println();
  float ccf=0, clf=0, cef=0, crf=0, csf=0;
  float lcf=0, llf=0, lef=0, lrf=0, lsf=0;
  float ecf=0, elf=0, eef=0, erf=0, esf=0;
  float rcf=0, rlf=0, ref=0, rrf=0, rsf=0;
  float scf=0, slf=0, sef=0, srf=0, ssf=0;
  
  if (ct!=0) {  ccf=float(cc)/ct; clf=float(cl)/ct; cef=float(ce)/ct; crf=float(cr)/ct; csf=float(cs)/ct; };
  if (lt!=0) {  lcf=float(lc)/lt; llf=float(ll)/lt; lef=float(le)/lt; lrf=float(lr)/lt; lsf=float(ls)/lt; };
  if (et!=0) {  ecf=float(ec)/et; elf=float(el)/et; eef=float(ee)/et; erf=float(er)/et; esf=float(es)/et; };
  if (rt!=0) {  rcf=float(rc)/rt; rlf=float(rl)/rt; ref=float(re)/rt; rrf=float(rr)/rt; rsf=float(rs)/rt; };
  if (st!=0) {  scf=float(sc)/st; slf=float(sl)/st; sef=float(se)/st; srf=float(sr)/st; ssf=float(ss)/st; };
  
  println("  Context frequencies");
  println("        % cc="+nf(ccf,0,2)+",  lc="+nf(lcf,0,2)+",  ec="+nf(ecf,0,2)+",  rc="+nf(rcf,0,2)+",  sc="+nf(scf,0,2)); 
  println("        % cl="+nf(clf,0,2)+",  ll="+nf(llf,0,2)+",  el="+nf(elf,0,2)+",  rl="+nf(rlf,0,2)+",  sl="+nf(slf,0,2)); 
  println("        % ce="+nf(cef,0,2)+",  le="+nf(lef,0,2)+",  ee="+nf(eef,0,2)+",  re="+nf(ref,0,2)+",  se="+nf(sef,0,2)); 
  println("        % cr="+nf(crf,0,2)+",  lr="+nf(lrf,0,2)+",  er="+nf(erf,0,2)+",  rr="+nf(rrf,0,2)+",  sr="+nf(srf,0,2)); 
  println("        % cs="+nf(csf,0,2)+",  ls="+nf(lsf,0,2)+",  es="+nf(esf,0,2)+",  rs="+nf(rsf,0,2)+",  ss="+nf(ssf,0,2)); 
  println();
   
  float cE = -( log2(ccf)*ccf + log2(clf)*clf + log2(cef)*cef + log2(crf)*crf + log2(csf)*csf ) ; 
  float lE = -( log2(lcf)*lcf + log2(llf)*llf + log2(lef)*lef + log2(lrf)*lrf + log2(lsf)*lsf ) ; 
  float eE = -( log2(ecf)*ecf + log2(elf)*elf + log2(eef)*eef + log2(erf)*erf + log2(esf)*esf ) ; 
  float rE = -( log2(rcf)*rcf + log2(rlf)*rlf + log2(ref)*ref + log2(rrf)*rrf + log2(rsf)*rsf ) ; 
  float sE = -( log2(scf)*scf + log2(slf)*slf + log2(sef)*sef + log2(srf)*srf + log2(ssf)*ssf ) ; 
  
  println("    Stream entropies: after C="+nf(cE,1,2)+", after L="+nf(lE,1,2)+", after E="+nf(eE,1,2)+", after R="+nf(rE,1,2)+", after S="+nf(sE,1,2));
  println("    Frequencies:            C="+nf(Cf,1,2)+",       L="+nf(Lf,1,2)+",       E="+nf(Ef,1,2)+",       R="+nf(Rf,1,2)+",       S="+nf(Sf,1,2));
  float Centropy=cE*Cf+lE*Lf+eE*Ef+rE*Rf+sE*Sf;
  cost = Centropy*rsymbols;    costWlcs = cost+int(log2(lCs));
  e = cost/symbols;    eWlcs = costWlcs/symbols; 
  println("***   Entropy (over remaining symbols ) = "+nf(Centropy,1,2));
  println("***  Amortized over all symbols :");
  println("*** Average context Entropy = "+nf(Centropy,1,2)+" bpt. Total cost = "+nf(Centropy*symbols,6,2)+" bits");
  println("*** Ccontext:                   Entropy = "+nf(e,1,2)+" bpt. Total cost = "+nf(cost,6,2)+" bits");
  println("*** counting RLE of leading Cs: Entropy = "+nf(eWlcs,1,2)+" bpt. Total cost = "+nf(costWlcs,6,2)+" bits");
  println("+++++++++++++++++++++++++++++++++++++++++++++");
  }
  void tighten(){
    if(size <= 51){
        size += 10;
    }
    else{
      size = 1;
    }    
  }
// PROJECT
    
   
// bend curves so that red edges goes below the blue edge and green goes above it -----check  
// trace curves and assign a different color to each (computed when 'w' is pressed)------check
// show curves as flat ribbons (Quad strips), toggle when 'q' is pressed-----check
// show curves as 4-sided tubes with minimal twist, toggle when 't' is pressed-----check
// change wiring to have a single loop
// animate weaving invasion (for example: bottom up, along loop, from selected corner...) -----key 'x'
// animate fly through the path of a loop    -----key 'y'

   void drawBCurve(int c){
       int curr = c;
       pt A = ccg(s(n(curr)));
            pt B = ccg(n(s(curr)));
            pt C = ccg(curr);
        
        vec normalV = Nt[t(curr)].make();  // getting corner normal vector
        normalV.add(Nt[t(s(n(curr)))]);    // normal + opposite triangle's normal vector
        normalV.makeUnit();  //get unit and multiply current size
        normalV.mul(size/3);
       
         vec AC = V(A, C);
         pt P0 = A;
         pt M0 = P((A.x + normalV.x+AC.x*(1/3)), (A.y + normalV.y+AC.y*(1/3)), (A.z + normalV.z+AC.z*(1/3)));
         pt P1 = C;
         pt M1 = P((C.x + normalV.x-AC.x*(1/3)), (C.y + normalV.y-AC.y*(1/3)), (C.z + normalV.z)-AC.z*(1/3));
        noFill();
        bezier(P0, M0, M1, P1);
       
        normalV = Nt[t(curr)].make();  // getting corner normal vector
        normalV.add(Nt[t(s(n(curr)))]);    // normal + opposite triangle's normal vector
        normalV.makeUnit();  //get unit and multiply current size
        normalV.mul(size);
        
       vec CB = V(C, B);
       P0 = C;
       P1 = B;
       M0 = P((C.x - normalV.x + CB.x*(1/3)), (C.y - normalV.y + CB.y*(1/3)), (C.z - normalV.z + CB.z*(1/3)));
       M1 = P((B.x - normalV.x - CB.x*(1/3)), (B.y - normalV.y - CB.y*(1/3)), (B.z - normalV.z - CB.z*(1/3))); 
        noFill(); bezier(P0, M0, M1, P1);
 }
   
  void showLacing(float w) {
    
    strokeWeight(r);
    for (int c=0; c<nc; c++) { 
      pt A=ccg(s(n(c)));
      pt B = ccg(n(s(c))); //<>//
      pt C = ccg(c); 
      
      //stroke(green); showEdge(C,A); stroke(red); showEdge(C,B);  
     
     vec normalV = Nt[t(c)].make();  // getting corner normal vector
     normalV.add(Nt[t(s(n(c)))]);    // normal + opposite triangle's normal vector
     normalV.makeUnit();             //get unit and multiply current size
     normalV.mul(size/3);
     
     vec AC = V(A, C);
     pt P0 = A;
     pt M0 = P((A.x + normalV.x+AC.x*(1/3)), (A.y + normalV.y+AC.y*(1/3)), (A.z + normalV.z+AC.z*(1/3)));
     pt P1 = C;
     pt M1 = P((C.x + normalV.x-AC.x*(1/3)), (C.y + normalV.y-AC.y*(1/3)), (C.z + normalV.z)-AC.z*(1/3));
     
     //green curve
     pt h0;
     noFill();
     stroke(green);
     bezier(P0, M0, M1, P1);

//     beginShape();
//     for (float t = 0.; t < 1; t += 0.01){
//       h0 = A(S((2*(t*t*t) - 3*(t*t) + 1), P0), S(((t*t*t) - 2*(t*t) + t), M0),  S((-2*(t*t*t) + 3*t*t), P1), S((t*t*t - t*t), M1));
//       vs(h0);
//     }
//     endShape(); 
    
     //red curve
     vec CB = V(C, B);
     P0 = C;
     P1 = B;
     M0 = P((C.x - normalV.x + CB.x*(1/3)), (C.y - normalV.y + CB.y*(1/3)), (C.z - normalV.z + CB.z*(1/3)));
     M1 = P((B.x - normalV.x - CB.x*(1/3)), (B.y - normalV.y - CB.y*(1/3)), (B.z - normalV.z - CB.z*(1/3)));     
     
     pt h1;
     noFill();
     stroke(red);
//     beginShape();
//     for (float t = 0; t < 1; t += 0.01){
//       h1 = A(A(S((2*(t*t*t) - 3*(t*t) + 1), P0), S(((t*t*t) - 2*(t*t) + t), M0)),  A(S((-2*(t*t*t) + 3*t*t), P1), S((t*t*t - t*t), M1)));
//       vs(h1);
//     }
//     endShape();
       bezier(P0, M0, M1, P1);
    }
    
    strokeWeight(1);
    }
    
     // trace curves and assign a different color to each (computed when 'w' is pressed)
  void showTraceCurve(){
    int col = 0;
    boolean pattern = false;
    color[] colorList = { black, blue, orange, cyan, green, dgreen, yellow, red, grey, magenta, dcyan, dred, dyellow, dblue, dmagenta, metal};
    VisitedV = new boolean[nc];

    for (int i = 0; i < nc; i++){
      if(!VisitedV[i]){
        println("visited");
        col %= 15;
        pattern = true;
        int curr = i;
        stroke(colorList[++col]);
        
        while(VisitedV[curr] == false){
          drawBCurve(curr);          
          VisitedV[curr] = true;
          if(pattern){
            curr = n(s(curr));
          }
          else{
            curr = s(n(curr));
          }
          pattern = !pattern;
       }
      }
    }
  }
  
  void showRibbon(){
    int col = 0;
    boolean pattern = false;
    color[] colorList = { black, blue, orange, cyan, green, dgreen, yellow, red, grey, magenta, dcyan, dred, dyellow, dblue, dmagenta, metal};
    VisitedV = new boolean[nc];
    for (int i = 0; i < nc; i++){
      if(!VisitedV[i]){
        println("visited");
        col %= 15;
        pattern = true;
        int curr = i;
        color color1 = colorList[col++];
        
        while(VisitedV[curr] == false){
          pt q = pattern ? ccg(s(n(n(s(curr))))) : ccg(n(s(s(n(curr)))));
          pt A = pattern ? ccg(n(s(curr))) : ccg(s(n(curr)));
          pt B = ccg(curr);
          pt C = pattern ? ccg(s(n(curr))) : ccg(n(s(curr)));
          pt D = pattern ? ccg(n(s(s(n(curr))))) : ccg(s(n(n(s(curr)))));
          
          float distance = d(A, B);
          vec tanA = M(V(q, A), V(A, B));
          vec tanB = M(V(A, B), V(B, C));
          vec tanC = M(V(B, C), V(C, D));
          
          vec normalV = cross(V(A, B), V(B, C));
          normalV.makeUnit();
          vec binormA = cross(V(A, B), normalV);
          vec binormC = cross(V(B, C), normalV);
          binormA.makeUnit();
          binormC.makeUnit();
          binormA.mul(2);          
          binormC.mul(2);
          
          pt pt1 = M(A, B);
          pt pt2 = S(M(A, B), 1.0, binormA);
          pt pt3 = S(M(B, C), 1.0, binormC);
          pt pt4 = M(B, C);
          pt pt5 = S(pt2, 1.0, normalV);
          pt pt6 = S(pt3, 1.0, normalV);
          pt pt7 = S(pt1, 1.0, normalV);
          pt pt8 = S(pt4, 1.0, normalV);
          
          fill(color1); stroke(color1);
          beginShape();
          vertex(pt1.x, pt1.y, pt1.z);
          vertex(pt2.x, pt2.y, pt2.z);
          vertex(pt3.x, pt3.y, pt3.z);
          vertex(pt4.x, pt4.y, pt4.z);
          endShape(CLOSE);
          tanA.makeUnit();
          tanA.mul(distance);
          
          distance = d(B, C);
          tanB.makeUnit();
          tanB.mul(distance);
          
          tanC.makeUnit();
          distance = d(C, D);
          tanC.mul(distance);
          
          if(showQuad){
            drawQuad(pt1, pt2, pt3, pt4, pt5, pt6, pt7, pt8, color1);
          }
          
          VisitedV[curr] = true;
          curr = pattern ? s(n(curr)) : n(s(curr));
          pattern=!pattern;
        }
      }
    }
  }
    
   void drawQuad(pt pt1, pt pt2, pt pt3, pt pt4, pt pt5, pt pt6, pt pt7, pt pt8, color color1){
          fill(color1); stroke(color1);
          //bottom
          beginShape();
          vertex(pt1.x, pt1.y, pt1.z);
          vertex(pt2.x, pt2.y, pt2.z);
          vertex(pt3.x, pt3.y, pt3.z);
          vertex(pt4.x, pt4.y, pt4.z);
          endShape(CLOSE);
          
          //left
          beginShape();
          vertex(pt2.x, pt2.y, pt2.z);
          vertex(pt5.x, pt5.y, pt5.z);
          vertex(pt6.x, pt6.y, pt6.z);
          vertex(pt3.x, pt3.y, pt3.z);
          endShape(CLOSE);
          
          //right
          beginShape();
          vertex(pt1.x, pt1.y, pt1.z);
          vertex(pt7.x, pt7.y, pt7.z);
          vertex(pt8.x, pt8.y, pt8.z);
          vertex(pt4.x, pt4.y, pt4.z);
          endShape(CLOSE);
          
          //top
          beginShape();
          vertex(pt5.x, pt5.y, pt5.z);
          vertex(pt7.x, pt7.y, pt7.z);
          vertex(pt8.x, pt8.y, pt8.z);
          vertex(pt6.x, pt6.y, pt6.z);
          endShape(CLOSE);          
   } 
   
   void  WeaveInvasion(){
     for(int i = 0; i < laceCount; i++){
       drawBCurve(i);
     }
     laceCount++;
     if(laceCount>nc) laceCount = 0;
     
   }
 
   void flyThrough(){
     vec normalV = Nt[t(flyCount)].make();
     normalV.makeUnit();
     C.flyThrough(M, flyCount, normalV);
     if(alternate){
       flyCount = s(n(flyCount));
     }
     else{
       flyCount = n(s(flyCount));
     }
     alternate = !alternate;
   }
    
}  // ==== END OF MESH CLASS
  
float log2(float x) {float r=0; if (x>0.00001) { r=log(x) / log(2);} ; return(r);}
vec labelD=new vec(-10,-10, 2);           // offset vector for drawing labels
int maxr=1;
