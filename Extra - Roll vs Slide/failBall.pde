    

public class failBall{
  pt[] P;
  float m;
  pt AAA = new pt(0,0);
  vec RRR;
  float R;
  pt center;
  vec V;
  vec A;
  float t;
  //left is 1, right is 2, vertical is 0
  int direction;
  float time = 0.166f;
  public failBall(pt[] P, float t){
    m = 0.1;
    this.t = t;
    this.P = P;
    R = 10;
    vec hori = new vec(R, 0);
    V = new vec(0,0);
    A = new vec(0,0); 
    center = computeCenter();
    direction = computeDirection();
    AAA = new pt(center.x+hori.x, center.y+hori.y);
    RRR = new vec(R, 0);
  }
  
  public int computeDirection(){
    vec normal = new vec(0,1);
    if(det(V, normal) >= 0){
      direction = 2;
    }
    else if(det(V, normal) < 0){
      direction = 1;    
    }
    return direction;
  }
  
  public vec computeA(){
    if(state == 2){
      m = 0.01;
    }
    else{
      m =0.1;
    }
    
    vec G = new vec(0, 1);
    vec N = computeNormal(P, t);
    vec ADirection = R(N);
    vec normalA = computeCentralA();
    //Judge if the ball will fall
    if(angle(N, G) > -PI/2 && angle(N,G) < PI/2){
      A = G;
    }
    else{
      float angle;
      if(angle(N,G) > PI/2){
        angle = PI/2 - (PI - angle(N,G));
      }
      else{
        angle = PI/2 - angle(N,G);
      }
      float ALength = n(G) * sin(angle);
      A = ADirection.scaleBy(ALength * (1-m));
    }
    stroke(color(255, 0, 255));
    arrow(center, 20, A);
    
    A.add(normalA);
    
    return A;
  }
  
  public vec computeCentralA(){
    vec ADirection = computeNormal(P,t);
    float ALength = n(V) * n(V) / GetCurvature(P,t);   
    vec result = ADirection.scaleBy(ALength * 2.5);
    stroke(green);
    arrow(center, 20, result);
    println("centralA = (" + A.x + "," + A.y + ")");
    return result;
  }
  
  public pt computeCenter(){
    vec N = computeNormal(P, t);
    pt center = groundCurve(P, t).add(N.scaleBy(R));
    return center;
  }
  
  public void drawBall(){
    stroke(black);
    fill(red);
    show(center, R);
    if(state == 2){
      fill(blue);
      show(AAA, 2);  
    }
    
  }
  
  public void update(pt[] P){
    direction = computeDirection();
    A = computeA();
//    vec N = computeNormal(P, t);
//    
//    vec VDirection;
//    if(direction == 1){
//      VDirection = R(R(R(N)));
//    }
//    else{
//      VDirection = R(N);
//    }
//    
//    
//    vec VLen = V.add(A.scaleBy(0.033));
//    float VLength = n(V);
//    V = VDirection.scaleBy(VLength);
    V = V.add(A.scaleBy(0.033));
    this.P = P; 
    center = computeCenter();
    
    computeNextT();
    printStatus();
  
    
  }
  
  public void printStatus(){
    println("V = (" + V.x + "," + V.y + ")");
    println("A = (" + A.x + "," + A.y + ")");
    println("t = " + t);
    println("Direction = " + direction);
    stroke(blue); 
    arrow(center, 5, V);
    stroke(red);
    arrow(center, 20, A);
  }
  
  public void computeNextT(){

    float distance = (n(V) * time) + 0.5 * n(A) * time * time;
    //distance++;
    //distance += (0.5 * n(A) * time * time);
    float disToGo = 0f;
    while(disToGo < distance){
      if(direction == 2){
        pt first = groundCurve(P, t);
        pt second = groundCurve(P, t+0.0001);
        disToGo += d(first, second);
        t += 0.0001;
      }
      else if(direction == 1){
        pt first = groundCurve(P, t);
        pt second = groundCurve(P, t-0.0001);
        disToGo += d(first, second);
        t -= 0.0001;
      }
    }
    
    float arcLength = distance;
    float P = 2*PI*R;
    float RotateAngle = arcLength/P * 2 * PI;
    if(direction == 2){
      RotateAngle = RotateAngle;
    }
    else{
      RotateAngle = -RotateAngle;
    }
    RRR = RRR.rotateBy(RotateAngle);
    println("Distance = " + d(center, AAA));
    println("RRR = " + n(RRR));
    //AAA = center.add(RRR);
    AAA = new pt(center.x+RRR.x, center.y+RRR.y);
    
  }
  
}
