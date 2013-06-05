
/*

 GLSL Sphere Displacement by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a sphere by subdividing an icosahedron. Storing it in a PShape.
 Displacing it outwards through GLSL with shader-based procedural noise.

 c = cycle through the color maps

 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final

 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.

*/

int subdivisionLevel = 8; // number of times the icosahedron will be subdivided
int dim = 300; // the grid dimensions of the heightmap
int blurFactor = 3; // the blur for the displacement map (to make it smoother)
float resizeFactor = 0.2; // the resize factor for the displacement map (to make it smoother)
float displaceStrength = 0.75; // the displace strength of the GLSL shader displacement effect

PShape sphere; // PShape to hold the geometry, textures, texture coordinates etc.
PShader displace; // GLSL shader

PImage[] images = new PImage[2]; // array to hold 2 input images
int currentColorMap = 1; // variable to keep track of the current colorMap

void setup() {
  size(1280, 720, P3D); // use the P3D OpenGL renderer

  // load the images from the _Images folder (relative path from this sketch's folder)
  images[0] = loadImage("../_Images/Texture01.jpg");
  images[1] = loadImage("../_Images/Texture02.jpg");

  displace = loadShader("displaceFrag.glsl", "displaceVert.glsl"); // load the PShader with a fragment and a vertex shader
  displace.set("displaceStrength", displaceStrength); // set the displaceStrength
  displace.set("colorMap", images[currentColorMap]); // set the initial colorMap
  
  sphere = createIcosahedron(subdivisionLevel); // create the subdivided icosahedron PShape (see custom creation method) and put it in the global sphere reference
}

void draw() {
  pointLight(255, 255, 255, 2*(mouseX-width/2), 2*(mouseY-height/2), 500); // required for texLight shader

  translate(width/2, height/2); // translate to center of the screen
  rotateX(radians(60)); // fixed rotation of 60 degrees over the X axis
  rotateZ(frameCount*0.005); // dynamic frameCount-based rotation over the Z axis

  background(0); // black background
  perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
  scale(200); // scale by 200

  displace.set("time", millis()/5000.0); // feed time to the GLSL shader
  shader(displace); // use shader
  shape(sphere); // display the PShape

  // write the fps and the current colorMap in the top-left of the window
  frame.setTitle(" " + int(frameRate) + " | colorMap: " + currentColorMap);
}

void keyPressed() {
  if (key == 'c') { currentColorMap = ++currentColorMap%images.length; displace.set("colorMap", images[currentColorMap]); } // cycle through colorMaps (set variable and set colorMap in PShader)
}

