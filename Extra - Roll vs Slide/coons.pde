
vec computeNormal(pt[] P, float t){
  pt Left = B(P[0], P[1], P[2], P[3], P[4], t-0.01);
  pt Right = B(P[0], P[1], P[2], P[3], P[4], t+0.01);
  vec LR = V(Left, Right);
  vec N = LR.left().left().left();
  
  pt mid = B(P[0], P[1], P[2], P[3], P[4], t);
  N.normalize();
  return N;
}


pt groundCurve(pt[] P, float t){
  pt Lt = B(P[0], P[1], P[2], P[3], P[4], t);
  return Lt;
}

float computeCurveLength(pt[] P){
  float L = 0;
  for(float t = 0; t< 1.00; t+=0.01){
     L+= d(groundCurve(P,t), groundCurve(P,t+0.01));
  }
  return L;
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

//***********************Bezier calculation**********************
// The following codes are imported and modified based on http://blog.avangardo.com/2010/10/c-implementation-of-bezier-curvature-calculation/

public vec GetDerivate(pt[] p, float t)
{
 groundCurve(p, t);
 
 float tSquared = t * t;
 float s0 = -3 + 6 * t - 3 * tSquared;
 float s1 = 3 - 12 * t + 9 * tSquared;
 float s2 = 6 * t - 9 * tSquared;
 float s3 = 3 * tSquared;
 float resultX = p[0].x * s0 + p[1].x * s1 + p[2].x * s2 + p[3].x * s3;
 float resultY = p[0].x * s0 + p[1].y * s1 + p[2].x * s2 + p[3].y * s3;
 return new vec(resultX, resultY);
}

public vec GetSecondDerivate(pt[] p, float t)
{
 groundCurve(p, t);
 
 float s0 = 6 - 6 * t;
 float s1 = -12 + 18 * t;
 float s2 = 6 - 18 * t;
 float s3 = 6 * t;
 float resultX = p[0].x * s0 + p[1].x * s1 + p[2].x * s2 + p[3].x * s3;
 float resultY = p[0].y * s0 + p[1].y * s1 + p[2].y * s2 + p[3].y * s3;
 return new vec(resultX, resultY);
}

public float GetCurvature(pt[] p, float t)
{
 groundCurve(p, t);
 
 vec d1 = GetDerivate(p, t);
 vec d2 = GetSecondDerivate(p, t);
 
 float r1 = sqrt(pow(d1.x * d1.x + d1.y * d1.y, 3f));
 float r2 = abs(d1.x * d2.y - d2.x * d1.y);
 return r1 / r2;
}




