//**************************************
// 3D POINTS AND VECTOR CLASSES
// Written by Jarek Rossignac,  June 2006
//*************************************

// ******************************************************************************************** SHORT CUTS 
// ===== make
pt P(float x, float y, float z) {return new pt(x,y,z); };                            // make point (x,y,z)
vec V(float x, float y, float z) {return new vec(x,y,z); };                          // make vector (x,y,z)
pt P(pt P) {return new pt(P.x,P.y,P.z); };                                           // make copy of point
vec V(vec V) {return new vec(V.x,V.y,V.z); };                                        // make copy of vector V
vec V(pt P, pt Q) {return new vec(Q.x-P.x,Q.y-P.y,Q.z-P.z);};                        // PQ
vec N(pt A, pt B, pt C) {return C(V(A,B),V(A,C)); };                             // normal to triangle (not unit)

// ===== add, scale, normalize, combine
pt A(pt A, pt B) {return new pt(A.x+B.x,A.y+B.y,A.z+B.z); };                                    // A+B
pt A(pt A, pt B, pt C, pt D) {return new pt(A.x+B.x+C.x+D.x, A.y+B.y+C.y+D.y, A.z+B.z+C.z+D.z);}
pt A(pt A, float s, pt B) {return new pt(A.x+s*B.x,A.y+s*B.y,A.z+s*B.z); };                     // A+sB
pt S(float s, pt A) {return new pt(s*A.x,s*A.y,s*A.z); };                                       // sA
vec U(vec V) {float n = n(V); if (n==0) return V(0,0,0); else return V(V.x/n,V.y/n,V.z/n);};    // V/||V||
vec S(float s,vec V) {return new vec(s*V.x,s*V.y,s*V.z);};                                      // sV

// ===== (weighted) average
pt M(pt A, pt B) {return P((A.x+B.x)/2.0,(A.y+B.y)/2.0,(A.z+B.z)/2.0); }                             // (A+B)/2
pt M(pt A, pt B, pt C) {return new pt((A.x+B.x+C.x)/3.0,(A.y+B.y+C.y)/3.0,(A.z+B.z+C.z)/3.0); };      // (A+B+C)/3
pt M(float a, pt A, float b, pt B) {return A(S(a,A),b,B);}                                            // aA+bB 
pt M(float a, pt A, float b, pt B, float c, pt C) {return A(S(a,A),M(b,B,c,C));}                      // aA+bB+cC 
pt M(float a, pt A, float b, pt B, float c, pt C, float d, pt D){return A(M(a,A,b,B),M(c,C,d,D));}    // aA+bB+cC+dD
vec M(vec U, vec V) {return new vec((U.x+V.x)/2.0,(U.y+V.y)/2.0,(U.z+V.z)/2.0); };                    // (U+V)/2
vec M(float a, vec U, float b, vec V) {return new vec(a*U.x+b*V.x,a*U.y+b*V.y,a*U.z+b*V.z);}          // aU+bV 

// ===== interpolate
pt S(pt A, float s, pt B) {return new pt(A.x+s*(B.x-A.x),A.y+s*(B.y-A.y),A.z+s*(B.z-A.z)); };  // A+sAB
pt S(pt P, float s, vec V) {return new pt(P.x + s*V.x, P.y + s*V.y, P.z + s*V.z); }            // P+sV
vec S(vec U,float s,vec V) {return new vec(U.x+s*(V.x-U.x),U.y+s*(V.y-U.y),U.z+s*(V.z-U.z));};            // (1-s)U+sV

// ===== translate  
pt S(pt P, vec V) {return new pt(P.x + V.x, P.y + V.y, P.z + V.z); }                          // P+V
pt T(pt P, float s, vec V) {float n = n(V); if (n>0) return S(P,s/n,V);  else return P(P);}   // P+sV/||V|| move from P along direction of V by distance s
pt T(pt P, float s, pt Q) {vec V = V(P,Q); return T(P,s,V) ; };                               // P+sPQ/||PQ|| move from P towards Q by distance s

// ===== render
void show(pt P, pt Q) {line(P.x,P.y,P.z,Q.x,Q.y,Q.z); };                                     // draws edge (P,Q)
void showEdge(pt P, pt Q) {line(P.x,P.y,P.z,Q.x,Q.y,Q.z); };                                     // draws edge (P,Q)
void showLineFrom (pt P, vec V) {line(P.x,P.y,P.z,P.x+V.x,P.y+V.y,P.z+V.z); }; 
void showLineFrom (pt P, vec V, float d) {line(P.x,P.y,P.z,P.x+d*V.x,P.y+d*V.y,P.z+d*V.z); }; 
void vs(pt P) {vertex(P.x,P.y,P.z);};                                                        // next vertex when drawing shapes between beginShape(); and endShape();

// ===== products
float d(vec U, vec V) {return U.x*V.x+U.y*V.y+U.z*V.z; };                                          //U*V dot product
float dot(vec U, vec V) {return U.x*V.x+U.y*V.y+U.z*V.z; };                                          //U*V dot product
vec C(vec U, vec V) {return V( U.y*V.z-U.z*V.y, U.z*V.x-U.x*V.z, U.x*V.y-U.y*V.x); };              // UxV cross product
vec cross(vec U, vec V) {return V( U.y*V.z-U.z*V.y, U.z*V.x-U.x*V.z, U.x*V.y-U.y*V.x); };              // UxV cross product
float m(vec U, vec V, vec W) {return d(C(U,V),W); };                                         // (UxV)*W  mixed product, determinant
float mixed(vec U, vec V, vec W) {return d(C(U,V),W); };                                         // (UxV)*W  mixed product, determinant

// ===== measures
float d(pt P, pt Q) {return sqrt(sq(Q.x-P.x)+sq(Q.y-P.y)+sq(Q.z-P.z)); };                       // ||AB|| distance
float n(vec V) {return sqrt(sq(V.x)+sq(V.y)+sq(V.z));};                                         // ||V||  norm
float n2(vec V) {return sq(V.x)+sq(V.y)+sq(V.z);};                                              // V^V     norm squared
boolean cw(vec U, vec V, vec W) {return m(U,V,W)>0; };                                           // (UxV)*W>0  U,V,W are clockwise
float area(pt A, pt B, pt C) {return n(N(A,B,C))/2; };                                          // area of triangle 
float volume(pt A, pt B, pt C, pt D) {return m(V(A,B),V(A,C),V(A,D))/6; };                      // volume of tet 
boolean cw(pt A, pt B, pt C, pt D) {return volume(A,B,C,D)>0; };                                 // tet is oriented so that A sees B, C, D clockwise 
vec B(vec U, vec V) {return U(C(C(U,V),U)); }                                                   // (UxV)xV unit normal to U in the plane UV
boolean parallel (vec U, vec V) {return n(C(U,V))<n(U)*n(V)*0.00001; }                          // true if U and V are almost parallel
float a (vec U, vec V) {if (parallel(U,V)) { if (d(U,V)>0) return 0; else return PI;}; vec T=U(U); vec B=B(U,V); return atan2(d(B,V),d(T,V)); }; // angle(U,V) between 0 and PI

// ===== mouse
pt Mouse() {return P(mouseX,mouseY,0);};                                          // current mouse location
pt Pmouse() {return P(pmouseX,pmouseY,0);};
vec MouseDrag() {return V(mouseX-pmouseX,mouseY-pmouseY,0);};                     // vector representing recent mouse displacement

// ******************************************************************************************** POINTS 
class pt { float x,y,z; 
  pt (float px, float py, float pz) {x = px; y = py; z = pz;};
  pt make() {return(new pt(x,y,z));};
  void show(int r) { pushMatrix(); translate(x,y,z); sphere(r); popMatrix();}; 
  void showLineTo (pt P) {line(x,y,z,P.x,P.y,P.z); }; 
  void setToPoint(pt P) { x = P.x; y = P.y; z = P.z;}; 
  void setTo(pt P) { x = P.x; y = P.y; z = P.z;}; 
  void setTo(float px, float py, float pz) {x = px; y = py; z = pz;}; 
  void setToMouse() { x = mouseX; y = mouseY; }; 
  void write() {println("("+x+","+y+","+z+")");};
  void addVec(vec V) {x += V.x; y += V.y; z += V.z;};
  void addScaledVec(float s, vec V) {x += s*V.x; y += s*V.y; z += s*V.z;};
  void moveTowards(float s, pt P) {x += s*(P.x-x); y += s*(P.y-y); z += s*(P.z-z);};
  void subVec(vec V) {x -= V.x; y -= V.y; z -= V.z;};
  void vert() {vertex(x,y,z);};
  void vertext(float u, float v) {vertex(x,y,z,u,v);};
  boolean isInWindow() {return(((x<0)||(x>width)||(y<0)||(y>height)));};
  void label(String s, vec D) {text(s, x+D.x, y+D.y, z+D.z);  };
  vec vecTo(pt P) {return(new vec(P.x-x,P.y-y,P.z-z)); };
  float disTo(pt P) {return(sqrt( sq(P.x-x)+sq(P.y-y)+sq(P.z-z) )); };
  vec vecToMid(pt P, pt Q) {return(new vec((P.x+Q.x)/2.0-x,(P.y+Q.y)/2.0-y,(P.z+Q.z)/2.0-z )); };
  vec vecToProp (pt B, pt D) {
      vec CB = this.vecTo(B); float LCB = CB.norm();
      vec CD = this.vecTo(D); float LCD = CD.norm();
      vec U = CB.make();
      vec V = CD.make(); V.sub(U); V.mul(LCB/(LCB+LCD));
      U.add(V);
      return(U);  
      };  
  void addPt(pt P) {x+=P.x; y+=P.y; z+=P.z;};
  void subPt(pt P) {x-=P.x; y-=P.y; z-=P.z; };
  void mul(float f) {x*=f; y*=f; z*=f;};
  void pers(float d) { y=d*y/(d+z); x=d*x/(d+z); z=d*z/(d+z); };
  void inverserPers(float d) { y=d*y/(d-z); x=d*x/(d-z); z=d*z/(d-z); };
  boolean coplanar (pt A, pt B, pt C) {return(abs(tetVol(this,A,B,C))<0.0001);};
  boolean cw (pt A, pt B, pt C) {return(tetVol(this,A,B,C)>0.0001);};
  } ;
 
// ******************************************************************************************** VECTORS 
class vec { float x,y,z; 
  vec (float px, float py, float pz) {x = px; y = py; z = pz;};
  void setTo (float px, float py, float pz) {x = px; y = py; z = pz;}; 
  vec make() {return(new vec(x,y,z));};
  void setToVec(vec V) { x = V.x; y = V.y; z = V.z;}; 
  void setTo(vec V) { x = V.x; y = V.y; z = V.z;}; 
  void show (pt P) {line(P.x,P.y, P.z,P.x+x,P.y+y,P.z+z); }; 
  void add(vec V) {x += V.x; y += V.y; z += V.z;};
  void addScaled(float m, vec V) {x += m*V.x; y += m*V.y; z += m*V.z;};
  void sub(vec V) {x -= V.x; y -= V.y; z -= V.z;};
  void mul(float m) {x *= m; y *= m; z *= m;};
  void div(float m) {x /= m; y /= m; z /= m;};
  void write() {println("("+x+","+y+","+z+")");};
  float norm() {return(sqrt(sq(x)+sq(y)+sq(z)));}; 
  void makeUnit() {float n=this.norm(); if (n>0.0001) {this.div(n);};};
  void back() {x= -x; y= -y; z= -z;};
  boolean coplanar (vec V, vec W) {return(abs(m(this,V,W))<0.0001);};
  boolean cw (vec U, vec V, vec W) {return(m(this,V,W)>0.0001);};
  } ;
  
  
// ******************************************************************************************** TRIANGLES  EDGES RAYS PLANES
vec triNormalFromPts(pt A, pt B, pt C) {vec N = cross(A.vecTo(B),A.vecTo(C));  return(N); };
boolean rayHitTri(pt E, pt M, pt A, pt B, pt C) { boolean s, sA, sB, sC; 
  s=(tetVolume(E,A,B,C)>0);  sA=(tetVolume(E,M,B,C)>0); sB=(tetVolume(E,A,M,C)>0);  sC=(tetVolume(E,A,B,M)>0); 
  return( (s==sA) && (s==sB) && (s==sC) );};
float rayDistTriPlane(pt E, pt M, pt A, pt B, pt C) { 
   vec AE = A.vecTo(E); vec AC = A.vecTo(C); vec AB = A.vecTo(B); vec EM = E.vecTo(M); 
   float s = - mixed(AE,AC,AB) / mixed(EM,AC,AB);
   return(s); };
pt triCenterFromPts(pt A, pt B, pt C) {return(new pt((A.x+B.x+C.x)/3 , (A.y+B.y+C.y)/3, (A.z+B.z+C.z)/3 )); };

// ******************************************************************************************** TETS 
float tetVol (pt A, pt B, pt C, pt D) { return(dot(triNormalFromPts(A,B,C),A.vecTo(D))); };
vec midVec(vec U, vec V) {return(new vec((U.x+V.x)/2,(U.y+V.y)/2,(U.z+V.z)/2)); };
pt midPt(pt A, pt B) {return(new pt((A.x+B.x)/2 , (A.y+B.y)/2, (A.z+B.z)/2 )); };
float tetVolume(pt E, pt A, pt B, pt C) {vec EA=E.vecTo(A); vec EB=E.vecTo(B); vec EC=E.vecTo(C); float v=mixed(EA,EB,EC); return(v/6); };

// ******************************************************************************************** RAYS 

// *****************************************BEZIER***************************************************
void bezier(pt A, pt B, pt C, pt D) {bezier(A.x,A.y,A.z,B.x,B.y,B.z,C.x,C.y,C.z,D.x,D.y,D.z);} // draws a cubic Bezier curve with control points A, B, C, D
// ********************************************************************************************

//************************************************************************
//**** ANGLES
//************************************************************************
float mPItoPIangle(float a) { if(a>PI) return(mPItoPIangle(a-2*PI)); if(a<-PI) return(mPItoPIangle(a+2*PI)); return(a);};
float Oto2PIangle(float a) { if(a>TWO_PI) return(Oto2PIangle(a-2*PI)); if(a<0) return(Oto2PIangle(a+2*PI)); return(a);};
float toDeg(float a) {return(a*180/PI);}
float toRad(float a) {return(a*PI/180);}
