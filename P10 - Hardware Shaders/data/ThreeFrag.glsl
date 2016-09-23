// Fragment shader
// The fragment shader is run once for every /pixel/ (not vertex!)
// It can change the color and transparency of the fragment.

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

// Space for uniform variables ( you can make your own! =D )
// Pass in things from Processing with shader.set("variable_name", value);
// Then declare them here with: uniform float variable_name;

uniform float time;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertPos;

void main() {  
  float intensity;
  
  // vec4 because RGBA
  vec4 color;
  // simple diffuse lighting
  intensity = max(0.0, dot(vertLightDir, vertNormal));
  

  color.r = (vertPos.x + 30) / 80 * intensity;
  color.g = (vertPos.y + 30) / 80 * intensity;
  color.b = (vertPos.z + 30) / 80 * intensity;
  color.a = 1.0;

  
  // The "return value" of a fragment shader
  gl_FragColor = color * vertColor;
}