import processing.video.*;

Capture cam;

PGraphics bufferA;
PGraphics bufferB;

PShader shader_buffer_a;
PShader shader_buffer_b;
PShader shader_final;


void setup() {
  fullScreen(P2D);
  //size(1280, 720, P3D);
  bufferA = createGraphics(width, height, P2D);
  bufferB = createGraphics(width, height, P2D);
  
  shader_buffer_a = loadShader("buffer_a_frag.glsl");
  shader_buffer_a.set("lastFrame", bufferA);
  
  shader_buffer_b = loadShader("buffer_b_frag.glsl");
  
  shader_final = loadShader("final_frag.glsl");
  shader_final.set("bufferB", bufferB);
  
  cam = new Capture(this, 640, 480, 30);
  cam.start();
}

void draw() {
  
  if(cam.available()) {
    cam.read();
  }
  
  bufferA.beginDraw();
  bufferA.shader(shader_buffer_a);
  bufferA.image(cam, 0, 0, width, height);
  bufferA.endDraw();
  
  bufferB.beginDraw();
  bufferB.shader(shader_buffer_b);
  bufferB.image(cam, 0, 0, width, height);
  bufferB.endDraw();
  
  shader_final.set("u_time", millis() / 1000.0);
  shader(shader_final);
  image(bufferA, 0, 0);
  
}