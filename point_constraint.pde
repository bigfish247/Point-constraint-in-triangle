PVector A;
PVector B;
PVector C;

//float xoff;
//float yoff;

boolean isStoped = false;
void setup(){
  size(600,600);
  
  A = new PVector(200,100);
  B = new PVector(500,399);
  C = new PVector(101,400);
  

  noStroke();
}

void draw(){
  
  background(50);
  
  // noise random point
  //xoff += 0.003f;
  //yoff += 0.005f;
  //float x = width/2 +150* (noise(xoff));
  //float y = height/2 +150 * (noise(yoff));
  
  float x = width/2 + 200* cos(TWO_PI/5000 * millis());
  float y = height/2 + 200 * sin(TWO_PI/5000 * millis());
  
  PVector constraint_point = PointOfConstraint(new PVector(x,y), A, B, C );
  
  pushStyle();
  stroke(255);
  line(A.x,A.y,B.x,B.y);
  line(A.x,A.y,C.x,C.y);
  line(B.x,B.y,C.x,C.y);
  
  popStyle();
  
  fill(255);
  ellipse(x,y,10,10);
  fill(255,255,0);
  ellipse(constraint_point.x, constraint_point.y,10,10);
}


PVector PointOfConstraint(PVector M, PVector _A, PVector _B, PVector _C){
  PVector ABM = PointToSeg(M, _A, _B, _C);
  PVector ACM = PointToSeg(M, _A, _C, _B);
  PVector BCM = PointToSeg(M, _B, _C, _A);
  
  float distOfAB = sqrt((ABM.x - M.x) * (ABM.x - M.x) + (ABM.y - M.y) * (ABM.y - M.y));
  float distOfAC = sqrt((ACM.x - M.x) * (ACM.x - M.x) + (ACM.y - M.y) * (ACM.y - M.y));
  float distOfBC = sqrt((BCM.x - M.x) * (BCM.x - M.x) + (BCM.y - M.y) * (BCM.y - M.y));
  
  PVector target_point;
  
  if(distOfAB <= distOfAC){
     if(distOfAB <= distOfBC)
       target_point = ABM;
     else
       target_point = BCM;
  }else{
     if(distOfAC <= distOfBC)
       target_point = ACM;
     else
       target_point = BCM;
  }
  
  if(PointInTri(M, _A, _B, _C)){
    return M;
  }else{
    return target_point;
  }
}

PVector PointToSeg(PVector M, PVector P1, PVector P2, PVector P3)
{
  PVector closest_point = new PVector(0,0);
  
  float cross = (P2.x - P1.x) * (M.x - P1.x) + (P2.y - P1.y) * (M.y - P1.y);
  if (cross <= 0){
    closest_point = P1;
    return closest_point;
  }
   
  float d2 = (P2.x - P1.x) * (P2.x - P1.x) + (P2.y - P1.y) * (P2.y - P1.y);
  if (cross >= d2){
     closest_point = P2;
     return closest_point;
  }
   
  float r = cross / d2;
  float px = P1.x + (P2.x - P1.x) * r;
  float py = P1.y + (P2.y - P1.y) * r;
  
  closest_point = new PVector(px,py); 
  
  return closest_point;
}

boolean PointInTri(PVector M, PVector _A, PVector _B , PVector _C){
  
  float TotalArea = CalcTriArea(_A, _B, _C);
  float Area1 = CalcTriArea(M, _B, _C);
  float Area2 = CalcTriArea(M, _A, _C);
  float Area3 = CalcTriArea(M, _A, _B);

  //println(round(Area1 + Area2 + Area3));
  if(round(Area1 + Area2 + Area3) > round(TotalArea))
  //if((Area1+Area2+Area3)>TotalArea)
    return false;
  else
    return true;
} 

float CalcTriArea(PVector P1, PVector P2, PVector P3)
{
  
  float det = 0.0f;
  PVector P1P2 = PVector.sub(P1,P2);
  PVector P1P3 = PVector.sub(P1,P3);

  det = abs(P1P2.x * P1P3.y - P1P2.y * P1P3.x);
  return (det / 2.0f);
  //return det;
}
