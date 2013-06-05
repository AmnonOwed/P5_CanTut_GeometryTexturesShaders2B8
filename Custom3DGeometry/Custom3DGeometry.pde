
/*

 Custom 3D Geometry by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 Creating custom 3D shapes (pyramids) using vertices, beginShape & endShape.
 For more information about Shapes see: http://processing.org/reference/beginShape_.html
 This example also displays OpenGL's automatic color interpolation between vertices.

 LEFT MOUSE BUTTON = toggle between black/white background
 RIGHT MOUSE BUTTON = toggle the use of lights()
 
 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final
 
*/

int NUMSHAPES = 150; // the number of flying pyramids
float MAXSPEED = 50; // the maximum speed at which a pyramid may move

ArrayList <Pyramid> shapes = new ArrayList <Pyramid> (); // arrayList to store all the shapes
boolean bLights, bWhitebackground; // booleans for toggling lights and background

void setup() {
  size(1280, 720, P3D); // use the P3D OpenGL renderer
  noStroke(); // turn off stroke (for the rest of the sketch)
  smooth(6); // set smooth level 6 (default is 2)
  // create all the shapes with a certain radius and height
  for (int i=0; i<NUMSHAPES; i++) {
    float r = random(25, 200);
    float f = random(2, 5);
    shapes.add( new Pyramid(f*r, r) );
  }
}

void draw() {
  background(bWhitebackground?255:0); // draw a white or black background
  if (bLights) { lights(); } // if true, use lights()
  perspective(PI/3.0, (float) width/height, 1, 1000000); // perspective to see close shapes
  // update and display all the shapes
  for (Pyramid p : shapes) {
    p.update();
    p.display();
  }
}

void mousePressed() {
  if (mouseButton==LEFT) { bWhitebackground = !bWhitebackground; } // toggle between black/white background
  if (mouseButton==RIGHT) { bLights = !bLights; } // toggle the use of lights()
}

