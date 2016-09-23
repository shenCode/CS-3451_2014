// Vertex shader
// The vertex shader is run once for every /vertex/ (not pixel)!
// It can change the (x,y,z) of the vertex, as well as its normal for lighting.

// Set automatically by Processing
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;

// Space for uniform variables ( you can make your own! =D )
// Pass in things from Processing with shader.set("variable_name", value);
// Then declare them here with: uniform float variable_name;


// Come from the geometry/material of the object
attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

// These values will be sent to the fragment shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertPos;

void main() {
  vertColor = color;
  
  vertNormal = normalize(normalMatrix * normal);
  
  // We have to create a copy of vertex because modifying
  // attribute variables is against the rules
  vec4 vert = vertex;  
  vec3 newPosition = vec3(vert) - normal * 20;
  newPosition.x += lightNormal.x * 25;
  newPosition.y += lightNormal.y * 25;
  
  // think of gl_Position as a return value for vertex shaders
  gl_Position = transform * vec4(newPosition, 1.0); 
  vertLightDir = -lightNormal;
  vertPos = vert;
}