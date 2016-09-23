/******** Editor of an Animated Coons Patch

Implementation steps:
**<01 Manual control of (u,v) parameters. 
**<02 Draw 4 boundary Curves CT(u), CB(u), SL(v), CR(v) using proportional Neville
**<03 Compute and show Coons point C(u,v)
**<04 Display quads filed one-by-one for the animated Coons patch
**<05 Compute and show normal at C(u,v) and a ball ON the patch

*/


//**<01: mouseMoved; 'v', draw: uvShow()
float u=0, v=0; 
void uvShow() { 
  fill(red);
  if(keyPressed && key=='v')  text("u="+u+", v="+v,10,30);
  u=mouseX/width;
  v=mouseY/height;
  noStroke(); fill(blue); ellipse(u*width,v*height,5,5); 
  }

pt coons(pt[] P, float s, float t){
  pt Lst = L(L(P[0], s, P[9]), t, L(P[3], s, P[6]));
  pt Lt = L(leftCurve(P, s, t), t, rightCurve(P, s, t));
  pt Ls = L(topCurve(P, s, t), s, downCurve(P, s, t));
  pt x = P(Lt.x+Ls.x-Lst.x, Lt.y+Ls.y-Lst.y, Lt.z+Ls.z-Lst.z); 
  return x;
}

pt leftCurve(pt[] P, float s, float t){
  float a = 0;
  float b = d(P[0], P[1]);
  float c = b + d(P[1], P[2]);
  float d = c + d(P[2], P[3]);
  b = b/d;
  c = c/d;
  d = 1;
  pt Lt = N(a, P[9], b, P[10], c, P[11], d, P[0], t);
  return Lt;
}

pt rightCurve(pt[] P, float s, float t){
  float a = 0;
  float b = d(P[0], P[1]);
  float c = b + d(P[1], P[2]);
  float d = c + d(P[2], P[3]);
  b = b/d;
  c = c/d;
  d = 1;
  pt Lt = N(a, P[3], b, P[4], c, P[5], d, P[6], t);
  return Lt;
}

pt topCurve(pt[] P, float s, float t) {
  float a = 0;
  float b = d(P[0], P[1]);
  float c = b + d(P[1], P[2]);
  float d = c + d(P[2], P[3]);
  b = b/d;
  c = c/d;
  d = 1;
  pt Ls = N(a, P[0], b, P[1], c, P[2], d, P[3], t);
  return Ls;
}

pt downCurve(pt[] P, float s, float t){
  float a = 0;
  float b = d(P[0], P[1]);
  float c = b + d(P[1], P[2]);
  float d = c + d(P[2], P[3]);
  b = b/d;
  c = c/d;
  d = 1;
  pt Ls = N(0, P[6], 0.33, P[7], 0.66, P[8], 1.0, P[9], t);
  return Ls;
}
//**************************** Neville ****************************
pt N(float a, pt A, float b, pt B, float t){
   float scalar = (t-a)/(b-a);
   return L(A, scalar, B);
}
pt N(float a, pt A, float b, pt B, float c, pt C, float t){
  return N(a, N(a, A, b, B, t), c, N(b, B, c, C, t), t);
}
pt N(float a, pt A, float b, pt B, float c, pt C, float d, pt D, float t){
  return N(a, N(a, A, b, B, c, C, t), d, N(b, B, c, C, d, D, t), t);
}

void shadeSurface(pt[] P, float e){ 
  for(float s=0; s<1.001-e; s+=e) for(float t=0; t<1.001-e; t+=e) 
  {beginShape(); v(coons(P,s,t)); v(coons(P,s+e,t)); v(coons(P,s+e,t+e)); v(coons(P,s,t+e)); endShape(CLOSE);}
  }

pts drawBorders(pt[] P, float e){
  pt[] TopCurve = {P[0], P[1], P[2], P[3]};
  pt[] RightCurve = {P[3], P[4], P[5], P[6]};
  pt[] DownCurve = {P[6], P[7], P[8], P[9]};
  pt[] LeftCurve = {P[9], P[10], P[11], P[0]};
  pts Neville = new pts(); Neville.declare();
  for(float i = 0f; i < 1f; i+=e){
    Neville.addPt(Neville(TopCurve, i));
  }
  for(float i = 0f; i < 1f; i+=e){
    Neville.addPt(Neville(RightCurve, i));
  }
  for(float i = 0f; i < 1f; i+=e){
    Neville.addPt(Neville(DownCurve, i));
  }
  for(float i = 0f; i < 1f; i+=e){
    Neville.addPt(Neville(LeftCurve, i));
  }
  Neville.drawClosedCurveAsRods(3);
  return Neville;
}

pt Neville(pt[] P, float t){
  float a = 0;
  float b = d(P[0], P[1]);
  float c = b + d(P[1], P[2]);
  float d = c + d(P[2], P[3]);
  b = b/d;
  c = c/d;
  d = 1;
  return N(a, P[0], b, P[1], c, P[2], d, P[3], t);
}


