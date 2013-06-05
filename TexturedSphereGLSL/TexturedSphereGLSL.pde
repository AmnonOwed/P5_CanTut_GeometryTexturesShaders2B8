
/*

 Textured Sphere GLSL by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a textured sphere by subdividing an icosahedron.
 Using the Processing's PShape to store and display the shape.
 Using a GLSL PShader to display the shape with dynamic lighting.

 Disclaimer:
 This is actually the default texLight shader from Processing, therefore NOT using
 a PShader would automatically achieve the same effect. However, once you achieve
 the effect manually, you are also able to tweak the PShader for custom effects.
 
 MOUSE CLICK + DRAG = arcball around the sphere
 MOUSE MOVE = change the lighting position

 +/- = zoom out / zoom in
 s = toggle shader (dynamic lighting) or default view

 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final

 For higher quality visuals, higher resolution textures are advised.

*/

PShape earth; // PShape to hold the geometry, textures, texture coordinates etc.
int subdivisionLevel = 6; // number of times the icosahedron will be subdivided
float zoom = 250; // scale factor aka zoom
boolean useShader = true; // boolean to toggle shader of regular view

PVector rotation = new PVector(); // vector to store the rotation
PVector velocity = new PVector(); // vector to store the change in rotation
float rotationSpeed = 0.02; // the rotation speed

PShader shader; // GLSL shader that can be applied to lighted textured geometry

void setup() {
  size(1280, 720, P3D); // use the P3D OpenGL renderer
  earth = createIcosahedron(subdivisionLevel); // create the subdivided icosahedron PShape (see custom creation method) and put it in the global earth reference
  shader = loadShader("shaderFrag.glsl", "shaderVert.glsl"); // load the PShader with a fragment and a vertex shader
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

  // render the PShape with or without the shader
  if (useShader) {
    // set the lightPosition according to the mouse position
    pointLight(255, 255, 255, 2*(mouseX-width/2), 2*(mouseY-height/2), 500);
    shader(shader);
  } else {
    resetShader();
  }

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
  if (key == 's') { useShader = !useShader; } // toggle shader or regular view
}

