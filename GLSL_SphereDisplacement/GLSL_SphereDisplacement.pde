
/*

 GLSL Sphere Displacement by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a sphere by subdividing an icosahedron. Storing it in a PShape.
 Displacing it outwards with GLSL (fragment and vertex) shaders based on input textures.
 The input textures for both the color and the displacement can be changed in realtime.

 c = cycle through the color maps
 d = cycle through the displacement maps

 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final

 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.

*/

int subdivisionLevel = 8; // number of times the icosahedron will be subdivided
int dim = 300; // the grid dimensions of the heightmap
int blurFactor = 3; // the blur for the displacement map (to make it smoother)
float resizeFactor = 0.2; // the resize factor for the displacement map (to make it smoother)
float displaceStrength = 3.5; // the displace strength of the GLSL shader displacement effect

PShape sphere; // PShape to hold the geometry, textures, texture coordinates etc.
PShader displace; // GLSL shader

PImage[] colorMaps = new PImage[3]; // array to hold 3 colorMaps
PImage[] displacementMaps = new PImage[3]; // array to hold 3 displacementMap 
int currentColorMap, currentDisplacementMap = 2; // variables to keep track of the current maps (also used for setting them)

void setup() {
  size(1280, 720, P3D); // use the P3D OpenGL renderer

  // load the images from the _Images folder (relative path from this sketch's folder)
  colorMaps[0] = loadImage("../_Images/Texture01.jpg");
  colorMaps[1] = loadImage("../_Images/Texture02.jpg");
  colorMaps[2] = loadImage("../_Images/Texture03.jpg");

  // create the displacement maps from the images
  displacementMaps[0] = imageToDisplacementMap(colorMaps[0]);
  displacementMaps[1] = imageToDisplacementMap(colorMaps[1]);
  displacementMaps[2] = imageToDisplacementMap(colorMaps[2]);

  displace = loadShader("displaceFrag.glsl", "displaceVert.glsl"); // load the PShader with a fragment and a vertex shader
  displace.set("displaceStrength", displaceStrength); // set the displaceStrength
  resetMaps(); // set the color and displacement maps
  sphere = createIcosahedron(subdivisionLevel); // create the subdivided icosahedron PShape (see custom creation method) and put it in the global sphere reference
}

void draw() {
  pointLight(255, 255, 255, 2*(mouseX-width/2), 2*(mouseY-height/2), 500); // required for texLight shader

  translate(width/2, height/2); // translate to center of the screen
  rotateX(radians(60)); // fixed rotation of 60 degrees over the X axis
  rotateZ(frameCount*0.01); // dynamic frameCount-based rotation over the Z axis

  background(0); // black background
  perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
  scale(100); // scale by 100

  shader(displace); // use shader
  shape(sphere); // display the PShape

  // write the fps, the current colorMap and the current displacementMap in the top-left of the window
  frame.setTitle(" " + int(frameRate) + " | colorMap: " + currentColorMap + " | displacementMap: " + currentDisplacementMap);
}

// a separate resetMaps() method, so the images can be change dynamically
void resetMaps() {
  displace.set("colorMap", colorMaps[currentColorMap]);
  displace.set("displacementMap", displacementMaps[currentDisplacementMap]);
}

// convenience method to create a smooth displacementMap
PImage imageToDisplacementMap(PImage img) {
  PImage imgCopy = img.get(); // get a copy so the original remains intact
  imgCopy.resize(int(imgCopy.width*resizeFactor), int(imgCopy.height*resizeFactor)); // resize
  if (blurFactor >= 1) { imgCopy.filter(BLUR, blurFactor); } // apply blur
  return imgCopy;
}

void keyPressed() {
  if (key == 'c') { currentColorMap = ++currentColorMap%colorMaps.length; resetMaps(); } // cycle through colorMaps (set variable and call resetMaps() method)
  if (key == 'd') { currentDisplacementMap = ++currentDisplacementMap%displacementMaps.length; resetMaps(); } // cycle through displacementMaps (set variable and call resetMaps() method)
}

