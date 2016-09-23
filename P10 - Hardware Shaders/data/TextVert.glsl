// Vertex shader
// The vertex shader is run once for every /vertex/ (not pixel)!
// It can change the (x,y,z) of the vertex, as well as its normal for lighting.

// Our shader uses both texture and light variables
#define PROCESSING_TEXLIGHT_SHADER

// Set automatically by Processing
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform mat4 texMatrix;


// Come from the geometry/material of the object
attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

// These values will be sent to the fragment shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() {
  vertColor = color;
  
  vertNormal = normalize(normalMatrix * normal);
  
  // We have to create a copy of vertex because modifying
  // attribute variables is against the rules
  vec4 vert = vertex;
  
  // think of gl_Position as a return value for vertex shaders
  gl_Position = transform * vert; 
  vertLightDir = -lightNormal;
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}