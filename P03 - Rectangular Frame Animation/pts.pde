//*****************************************************************************
// TITLE:         Point sequence for polylines and polyloops  
// AUTHOR:        Prof Jarek Rossignac
// DATE CREATED:  September 2012
// EDITS:         Last revised Sept 10, 2012
//*****************************************************************************
class pts {
 int nv=0;
 int pv = 0;                              // picked vertex 
 int maxnv = 1000;                         //  max number of vertices
 pt[] G = new pt [maxnv];                 // geometry table (vertices)
  pts() {}
  pts declare() {for (int i=0; i<maxnv; i++) G[i]=P(); return this;}               // init points
  pts empty() {nv=0; return this;}
  pts addPt(pt P) { G[nv].setTo(P); pv=nv; nv++;  return this;}
  pts addPt(float x,float y) { G[nv].x=x; G[nv].y=y; pv=nv; nv++; return this;}
  pts resetOnCircle(int k) { // init the points to be on a circle
    pt C = ScreenCenter(); 
    /*for (int i=0; i<k; i++) addPt(R(P(C,V(0,-width/5)),2.*PI*i/k,C));*/
    addPt(R(P(C, V(0,-width/5)), 0., C));
    addPt(R(P(C, V(0,-width/5)), 2.*PI/6, C ));
    addPt(R(P(C, V(0,-width/5)), 2.*PI/2, C ));
    addPt(R(P(C, V(0,-width/5)), 2.*PI*2/3, C ));
    return this;
    } 
  pts resetOnCircle(pt c, int k){// init the point to be the input center
   /* for(int i = 0; i < k; i++){
      if(i%2 == 0)
        addPt(R(P(c,V(0,-width/20)),2.*PI*i/k,c));
       else
        addPt(R(P(c,V(0,-width/20)),2.*PI*i/k,c));        
    }*/
    addPt(R(P(c, V(0,-width/20)), 0., c ));
    addPt(R(P(c, V(0,-width/20)), 2.*PI/6, c ));
    addPt(R(P(c, V(0,-width/20)), 2.*PI/2, c ));
    addPt(R(P(c, V(0,-width/20)), 2.*PI*2/3, c ));

    return this;
  }
  
  boolean equals(pt a, pt b) {
    if((a.x == b.x) && (a.y == b.y)) {
      return true;
    }
    else{
    return false;
    }
  }
  pts deletePickedPt() {for(int i=pv; i<nv; i++) G[i].setTo(G[i+1]); pv=max(0,pv-1); nv--;  return this;}
  pts setPt(pt P, int i) { G[i].setTo(P); return this;}
  pts IDs() {
    for (int v=0; v<nv; v++) { 
      fill(white); show(G[v],13); fill(black); 
      if(v<10) label(G[v],str(v));  else label(G[v],V(-5,0),str(v)); 
      }
    noFill();
    return this;
    }
  void pickClosest(pt M) {pv=0; for (int i=1; i<nv; i++) if (d(M,G[i])<d(M,G[pv])) pv=i;}
  
  pt pickClosests(pt M, pt Centroid){  // get the closer point set include centroid
    pv = 0; 
    for (int i = 1; i < nv; i ++){
      if(d(M, G[i]) < d(M, G[pv])) {
        pv = i;
      }
    }
    if(d(M, Centroid) < d(M, G[pv])) return Centroid;
    else return G[pv];
  }
  
  
  pts showPicked() {show(G[pv],13); return this;}
  pts draw(color c) {fill(c); for (int v=0; v<nv; v++) show(G[v],13); return this;}
  pts draw() {for (int v=0; v<nv; v++) show(G[v],13); return this;}
  pts drawCurve() {beginShape(); for (int v=0; v<nv; v++) G[v].v(); endShape(); return this;}

  // ************ to transfrom all points
  pt Centroid() {pt C=P(); for (int i=0; i<nv; i++) C.add(G[i]); return P(1./nv,C);}
  
  pts dragPicked() { G[pv].moveWithMouse(); return this;}      // moves selected point (index p) by amount mouse moved recently
  pts dragAll() { for (int i=0; i<nv; i++) G[i].moveWithMouse(); return this;}      // moves selected point (index p) by amount mouse moved recently
  pts moveAll(vec V) {for (int i=0; i<nv; i++) G[i].add(V); return this;};   

  pts rotateAll(float a, pt C) {for (int i=0; i<nv; i++) G[i].rotate(a,C); return this;}; // rotates points around pt G by angle a
  pts rotateAllAroundCentroid(float a) {rotateAll(a,Centroid()); return this;}; // rotates points around their center of mass by angle a
  pts rotateAll(pt G, pt P, pt Q) {rotateAll(angle(V(G,P),V(G,Q)),G); return this;}; // rotates points around G by angle <GP,GQ>
  pts rotateAllAroundCentroid(pt P, pt Q) {rotateAll(Centroid(),P,Q); return this;}; // rotates points around their center of mass G by angle <GP,GQ>

  pts scaleAll(float s, pt C) {for (int i=0; i<nv; i++) G[i].translateTowards(s,C); return this;};  
  pts scaleAllAroundCentroid(float s) {scaleAll(s,Centroid()); return this;};
  pts scaleAllAroundCentroid(pt M, pt P) {pt C=Centroid(); float m=d(C,M),p=d(C,P); scaleAll((p-m)/p,C); return this;};
  pts scaleAll(pt C, pt M, pt P) {float m=d(C,M),p=d(C,P); scaleAll((p-m)/p,C); return this;};
   
  // ************** to save points on file and read them back 
  void savePts(String fn) {
    String [] inppts = new String [nv+1];
    int s=0;
    inppts[s++]=str(nv);
    for (int i=0; i<nv; i++) inppts[s++]=str(G[i].x)+","+str(G[i].y);
    saveStrings(fn,inppts);
    };

  void loadPts(String fn) {
    String [] ss = loadStrings(fn);
    int s=0;  // offset for header
    int comma;   
    float x, y;   
    nv = int(ss[s++]); 
    for(int k=0; k<nv; k++) {
      int i=k+s; 
      comma=ss[i].indexOf(',');   
      x=float(ss[i].substring(0, comma));
      y=float(ss[i].substring(comma+1, ss[i].length()));
      G[k].setTo(x,y);
      };
    pv=0; // index of picked vertex
    } 
    
 }  // end class pts
