
/*

 Textured Sphere by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a textured sphere by subdividing an icosahedron.
 Using Processing's PShape to store and display the shape.
 
 The benefits of the current creation method are:
 1. Even distribution of vertices over the sphere
 2. No seam or pole problems in the texture coordinates
 
 MOUSE CLICK + DRAG = arcball around the sphere

 +/- = zoom out / zoom in

 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final

 For higher quality visuals, higher resolution textures are advised.

*/

PShape earth; // PShape to hold the geometry, textures, texture coordinates etc.
int subdivisionLevel = 6; // number of times the icosahedron will be subdivided
float zoom = 250; // scale factor aka zoom

PVector rotation = new PVector(); // vector to store the rotation
PVector velocity = new PVector(); // vector to store the change in rotation
float rotationSpeed = 0.02; // the rotation speed

void setup() {
  size(1280, 720, P3D); // use the P3D OpenGL renderer
  earth = createIcosahedron(subdivisionLevel); // create the subdivided icosahedron PShape (see custom creation method) and put it in the global earth reference
}

void draw() {      
  background(0); // black background
  perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
  translate(width/2, height/2); // translate to center of the screen

  // set rotation velocity with mouse drag
  if (mousePressed) {
    velocity.x -= (mouseY-pmouseY) * 0.01;
    velocity.y += (mouseX-pmouseX) * 0.01;
  }

  rotation.add(velocity); // add rotation velocity to rotation
  velocity.mult(0.95); // diminish the rotation velocity on each draw()

  rotateX(rotation.x*rotationSpeed); // rotation over the X axis
  rotateY(rotation.y*rotationSpeed); // rotation over the Y axis

  // zoom out/in with the -/+ keys
  if (keyPressed) {
    if (key == '-') { zoom -= 3; }
    if (key == '+' || key == '=') { zoom += 3; }
  }
  scale(zoom); // set the scale/zoom level

  shape(earth); // display the PShape

  frame.setTitle(" " + int(frameRate)); // write the fps in the top-left of the window
}

