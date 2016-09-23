
pt coons(pt[] P, float s, float t){
  pt Lst = L(L(P[4], P[0],s), L(P[7], P[11], s), t);
  pt Lt = L(leftCurve(P, s, t), rightCurve(P, s, t), t);
  pt Ls = L(topCurve(P, s, t), downCurve(P, s, t), s);
  pt x = P(Lt.x+Ls.x-Lst.x, Lt.y+Ls.y-Lst.y); 
  return x;
}

pt leftCurve(pt[] P, float s, float t){
  pt Lt = B(P[4], P[3], P[2], P[1], P[0], s);
  return Lt;
}

pt rightCurve(pt[] P, float s, float t){
  pt Lt = B(P[7], P[8], P[9], P[10], P[11], s);
  return Lt;
}

pt topCurve(pt[] P, float s, float t){
  pt Ls = N(0, P[4], 0.33, P[5], 0.66, P[6], 1.0, P[7], t);
  return Ls;
}

pt downCurve(pt[] P, float s, float t){
  pt Ls = N(0, P[0], 0.33, P[13], 0.66, P[12], 1.0, P[11], t);
  return Ls;
}
//**************************** Bezier ****************************

pt B(pt A, pt B, pt C, float t){
  return L(L(A, B, t), L(B, C, t), t);
}

pt B(pt A, pt B, pt C, pt D, float t){
  return L(B(A, B, C,t), B(B, C, D, t), t);
}

pt B(pt A, pt B, pt C, pt D, pt E, float t){
  return L(B(A, B, C, D, t), B(B, C, D, E, t), t);
}

//**************************** Neville ****************************
pt N(float a, pt A, float b, pt B, float t){
   float scalar = (t-a)/(b-a);
   return L(A, B, scalar);
}
pt N(float a, pt A, float b, pt B, float c, pt C, float t){
  return N(a, N(a, A, b, B, t), c, N(b, B, c, C, t), t);
}
pt N(float a, pt A, float b, pt B, float c, pt C, float d, pt D, float t){
  return N(a, N(a, A, b, B, c, C, t), d, N(b, B, c, C, d, D, t), t);
}
