public class ball{
  pt[] P;
  float m;
  pt AAA = new pt(0,0);
  vec RRR;
  float R;
  pt center;
  float V;
  float A;
  float t;
  //left is 1, right is 2
  int direction;

   float time = 0.166f; 
  public ball(pt[] P, float t){
    m = 0.1;
    this.t = t;
    this.P = P;
    R = 20;
    vec hori = new vec(R, 0);
    V = 0;
    A = 0; 
    center = computeCenter();
    //direction = computeDirection();
    AAA = new pt(center.x+hori.x, center.y+hori.y);
    RRR = new vec(R, 0);
  }
  
  public int computeDirection(){
    vec normal = new vec(0,1);
    if(V >= 0){
      direction = 2;
    }
    else {
      direction = 1;    
    }
    return direction;
  }
  
  public float computeA(int i){
    
    vec G = new vec(0, -10);
    vec N = computeNormal(P, t);
    vec ADirection = R(N);
//    float angle;
//    if(angle(N,G) > PI/2){
//      angle = PI/2 - (PI - angle(N,G));
//    }
//    else{
//      angle = PI/2 - angle(N,G);
//    }
//    float A = n(G) * sin(angle);

    float A = det(G, N);
    vec ADisplay = ADirection.scaleBy(A);
    stroke(color(255, 0, 0));
    arrow(center, 20, ADisplay);
    if(i == 1){
      return A;
    }
    else{
      return A / 1.4f;
    }
  }
  
//  public vec computeCentralA(){
//    vec ADirection = computeNormal(P,t);
//    float ALength = n(V) * n(V) / GetCurvature(P,t);   
//    vec result = ADirection.scaleBy(ALength * 2.5);
//    stroke(green);
//    arrow(center, 20, result);
//    println("centralA = (" + A.x + "," + A.y + ")");
//    return result;
//  }
//  
  public pt computeCenter(){
    vec N = computeNormal(P, t);
    pt center = groundCurve(P, t).add(N.scaleBy(R));
    return center;
  }
  
  public void drawBall(int i){
    stroke(black);
    if (i == 1) {fill(yellow);}
    else {fill (blue);}
    show(center, R);
    if(i == 2){
      fill(blue);
      show(AAA, 2);
    }
  }
  
  public void update(int i){
    direction = computeDirection();
    this.A = computeA(i);
    
//    vec N = computeNormal(P, t);
//    
//    vec VDirection;
//    if(direction == 1){
//      VDirection = R(R(R(N)));
//    }
//    else{
//      VDirection = R(N);
//    }
//    vec VLen = V.add(A.scaleBy(0.033));
//    float VLength = n(V);
//    V = VDirection.scaleBy(VLength);
    
    center = computeCenter();
    this.V = (this.V + (this.A*(0.0166)));
    
    //Show velocity
    vec N = computeNormal(P, t);
    vec VDirection = R(N);
    vec VDisplay = VDirection.scaleBy(V);
    stroke(color(0, 255, 0));
    arrow(center, 20, VDisplay);
    
    computeNextT();
    printStatus();
    
    
  }
  
  public void printStatus(){
    println("V = " + V);
    println("A = " + A);
    println("t = " + t);
    println("Direction = " + direction);
  }
  
  public void computeNextT(){
    float distance = V * time + 0.5 * A * time * time;
    distance = abs(distance);
    println("Distance = " + distance);
    //distance++;
    //distance += (0.5 * n(A) * time * time);
    float disToGo = 0f;
    float TIncreased = 0f;
    while(disToGo < distance){
      if(direction == 2){
        pt first = groundCurve(P, t);
        pt second = groundCurve(P, t+0.0001);
        disToGo += d(first, second);
        t += 0.0001;
        TIncreased += 0.0001;
      }
      else if(direction == 1){
        pt second = groundCurve(P, t);
        pt first = groundCurve(P, t-0.0001);
        disToGo += d(first, second);
        t -= 0.0001;
        println("AA");
      }
    }
    println("TIncreased = " + TIncreased);
    
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
