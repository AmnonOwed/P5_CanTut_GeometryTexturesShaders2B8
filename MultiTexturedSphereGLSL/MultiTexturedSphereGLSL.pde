
/*

 Multi-textured Sphere GLSL by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a multi-textured sphere by subdividing an icosahedron.
 Using the Processing's PShape to store and display the shape.
 Using a GLSL PShader to display the shape using multiple textures.
 
 MOUSE CLICK + DRAG = arcball around the sphere

 +/- = zoom out / zoom in
 c = toggle clouds texture layer
 l = toggle light source or night view

 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final

 Free low-resolution earth textures (day, night, specular, clouds) courtesy of:
 http://planetpixelemporium.com/earth.html
 For higher quality visuals, higher resolution textures are advised.

*/

PShape earth; // PShape to hold the geometry, textures, texture coordinates etc.
int subdivisionLevel = 6; // number of times the icosahedron will be subdivided
float zoom = 250; // scale factor aka zoom
boolean useClouds = true; // boolean to toggle clouds texture layer
boolean useLight = true; // toggle light source or night view

PVector rotation = new PVector(); // vector to store the rotation
PVector velocity = new PVector(); // vector to store the change in rotation
float rotationSpeed = 0.02; // the rotation speed
float timeSpeed = 0.00025; // the speed of time (relevant for the movement of the clouds)

PShader shader; // GLSL shader that can be applied to lighted textured geometry

void setup() {
  size(1280, 720, P3D); // use the P3D OpenGL renderer
  earth = createIcosahedron(subdivisionLevel); // create the subdivided icosahedron PShape (see custom creation method) and put it in the global earth reference
  shader = loadShader("shaderFrag.glsl", "shaderVert.glsl"); // load the PShader with a fragment and a vertex shader

  // load the 4 PImages (get higher resolution textures for better quality visuals)
  PImage tex0 = loadImage("earthmap1k.jpg"); // day
  PImage tex1 = loadImage("earthlights1k.jpg"); // night
  PImage tex2 = loadImage("earthspec1k.jpg"); // specular
  PImage tex3 = loadImage("earthcloudmap.jpg"); // clouds

  // Connect the images to the shader as textures
  shader.set("EarthDay", tex0);
  shader.set("EarthNight", tex1);
  shader.set("EarthGloss", tex2);
  shader.set("EarthClouds", tex3);
}

void draw() {      
  background(0); // black background
  perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
  translate(width/2, height/2); // translate to center of the screen

  // zoom out/in with the -/+ keys
  if (keyPressed) {
    if (key == '-') { zoom -= 3; }
    if (key == '+' || key == '=') { zoom += 3; }
  }
  scale(zoom); // set the scale/zoom level

  shader.set("Time", frameCount * timeSpeed ); // feed time to the shader (for the movement of the clouds)
  shader.set("useClouds", useClouds?1.0:0.0 ); // toggle the use of clouds through a float value (1 or 0)
  // set the light position according to sin/cos or set it to something far away
  pointLight(255, 255, 255, useLight?sin(frameCount*0.01)*800:0, 0, useLight?cos(frameCount*0.01)*800:-10000);
  shader(shader);

  // set rotation velocity with mouse drag
  if (mousePressed) {
    velocity.x -= (mouseY-pmouseY) * 0.01;
    velocity.y += (mouseX-pmouseX) * 0.01;
  }

  rotation.add(velocity); // add rotation velocity to rotation
  velocity.mult(0.95); // diminish the rotation velocity on each draw()

  rotateX(rotation.x*rotationSpeed); // rotation over the X axis
  rotateY(rotation.y*rotationSpeed); // rotation over the Y axis

  shape(earth); // display the PShape

  frame.setTitle(" " + int(frameRate)); // write the fps in the top-left of the window
}

void keyPressed() {
  if (key == 'c') { useClouds = !useClouds; } // toggle clouds texture layer
  if (key == 'l') { useLight = !useLight; } // light source or night view
}

