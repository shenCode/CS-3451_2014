PShader catShader, shadeOne, shadeTwo, shadeThree, shadeFour, ExtraCredit;
PImage catTexture;
int sphereSize = 120;
boolean stroke = false;

float offset = -10;

void setup() {
  size(640, 640, P3D);
  noStroke();
  fill(204);
  
  catTexture = loadImage("data/the_cat.png");
  catShader = loadShader("data/TextFrag.glsl", "data/TextVert.glsl");
  shadeOne = loadShader("data/OneFrag.glsl", "data/OneVert.glsl");
  shadeTwo = loadShader("data/TwoFrag.glsl", "data/TwoVert.glsl");
  shadeThree = loadShader("data/ThreeFrag.glsl", "data/ThreeVert.glsl");
  shadeFour= loadShader("data/FourFrag.glsl", "data/FourVert.glsl");
  ExtraCredit = loadShader("data/ECFrag.glsl", "data/ECVert.glsl");
}

float time = 1.0f;

void draw() {
  time += 0.01;
  
  background(0); 
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  if (mousePressed) 
    offset += (mouseX - pmouseX); /// float(width);
  directionalLight(204, 204, 204, -dirX, -dirY, -1);
  translate(width/2, height/2);
  
  // Picture in the background
  // Provided so that you can see "holes"
  // where the sphere is transparent, and have an
  // example of how to use textures with shaders
  
  shader(catShader);
    noStroke();
    fill(#00FFAA);
    textureMode(NORMAL);
    beginShape();
      texture(catTexture);
      vertex(-300, -300, -200, 0,0);
      vertex( 300, -300, -200, 1,0);
      vertex( 300,  300, -200, 1,1);
      vertex(-300,  300, -200, 0,1);
    endShape();
  
  // Sphere
  
  if (key == '1') {
    shader(shadeOne);
    textureMode(NORMAL);
    noStroke(); 
    beginShape();
      texture(catTexture);
      vertex(-300, -300, -200, 0,0);
      vertex( 300, -300, -200, 1,0);
      vertex( 300,  300, -200, 1,1);
      vertex(-300,  300, -200, 0,1);
    endShape();
  }
  
  else if (key == '2') {
    stroke(#FF0000);
    shader(shadeTwo);
    shadeTwo.set("time", time);
    textureMode(NORMAL);
    beginShape();
      texture(catTexture);
      vertex(-300, -300, -200, 0,0);
      vertex( 300, -300, -200, 1,0);
      vertex( 300,  300, -200, 1,1);
      vertex(-300,  300, -200, 0,1);
    endShape();
  }
  
  else if (key == '3') {
    shader(shadeThree);
    noStroke(); 
    textureMode(NORMAL);
    beginShape();
      texture(catTexture);
      vertex(-300, -300, -200, 0,0);
      vertex( 300, -300, -200, 1,0);
      vertex( 300,  300, -200, 1,1);
      vertex(-300,  300, -200, 0,1);
    endShape();
  }
  
  else if (key == '4') {
    stroke(#FF0000);
    shader(shadeFour);
    textureMode(NORMAL);
    beginShape();
      texture(catTexture);
      vertex(-300, -300, -200, 0,0);
      vertex( 300, -300, -200, 1,0);
      vertex( 300,  300, -200, 1,1);
      vertex(-300,  300, -200, 0,1);
    endShape();
  }
  
  else if (key == '5') {
      shader(ExtraCredit);
    textureMode(NORMAL);
    beginShape();
      texture(catTexture);
      vertex(-300, -300, -200, 0,0);
      vertex( 300, -300, -200, 1,0);
      vertex( 300,  300, -200, 1,1);
      vertex(-300,  300, -200, 0,1);
    endShape();
  }
  fill(#FFFFFF);
  
  sphereDetail(64);
  sphere(sphereSize);
  if (time >= 4) {time = 1f;}

}
