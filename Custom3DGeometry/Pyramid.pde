
// custom class to create a flying pyramid
class Pyramid {
  PVector[] v = new PVector[5]; // the 5 relative coordinates of the pyramid as an object
  color[] c = new color[5]; // the colors for each coordinate
  float pHeight, pRadius; // the height and base radius of the shape
  float speed, transparency; // the movement speed and the color transparency
  float x, y, z; // the position of the shape as a whole
  
  Pyramid(float pHeight, float pRadius) {
    this.pHeight = pHeight/2; // this is done so the pyramid rotates around the center (see createPyramid() method)
    this.pRadius = pRadius; // the radius of the shape
    speed = random(MAXSPEED/8, MAXSPEED); // set the speed randomly based on the global MAXSPEED variable
    createPyramid(); // set the relative coordinates of the pyramid as an object
    z = random(-5000, 750); // randomly set the z position of the shape as a whole
    reset(); // randomly set the x and y position of the shape as a whole and the colors of the shape
  }
  
  void createPyramid() {
    v[0] = new PVector(0, -pHeight, 0);                                      // top of the pyramid
    v[1] = new PVector(pRadius*cos(HALF_PI), pHeight, pRadius*sin(HALF_PI)); // base point 1
    v[2] = new PVector(pRadius*cos(PI), pHeight, pRadius*sin(PI));           // base point 2
    v[3] = new PVector(pRadius*cos(1.5*PI), pHeight, pRadius*sin(1.5*PI));   // base point 3
    v[4] = new PVector(pRadius*cos(TWO_PI), pHeight, pRadius*sin(TWO_PI));   // base point 4
  }

  // controls the z movement of the shape, when the z goes beyond the camera
  // it's reset to position in the distance and the xy position and colors are randomly set
  // the transparency is determined by the z position
  void update() {
    z += speed; // increase z by speed
    if (z > 750) { z = -5000; reset(); } // if beyond the camera, reset() and start again
    transparency = z<-2500?map(z, -5000, -2500, 0, 255):255; // far away slowly increase the transparency, within range is fully opaque
  }

  // displays the shape  
  void display() {
    pushMatrix(); // use push/popMatrix so each Shape's translation/rotation does not affect other drawings

    // move and rotate the shape as a whole    
    translate(x, y, z); // translate to the position of the shape
    rotateY(x + frameCount*0.01); // rotate around the Y axis based on the x position and frameCount
    rotateX(y + frameCount*0.02); // rotate around the X axis based on the y position and frameCount
    
    // draw the 4 side triangles of the pyramid, each connected to the top of the pyramid
    beginShape(TRIANGLE_FAN); // TRIANGLE_FAN is suited for this, it starts with the center point c[0]
    for (int i=0; i<5; i++) {
      fill(c[i], transparency); // use the color, but with the given z-based transparency
      vertex(v[i].x, v[i].y, v[i].z); // set the vertices based on the object coordinates defined in the createShape() method
    }
    // add the 'first base vertex' to close the shape
    fill(c[1], transparency);
    vertex(v[1].x, v[1].y, v[1].z);
    endShape(); // finalize the Shape
    
    // draw the base QUAD of the pyramid
    fill(c[1], transparency); // use a single color (optional: for vertex colors you can also put this in the for loop)
    beginShape(QUADS); // it's a QUAD so the QUADS shapeMode is the most suitable
    for (int i=1; i<5; i++) {
      vertex(v[i].x, v[i].y, v[i].z); // the 4 base points
    }
    endShape(); // finalize the Shape
    
    popMatrix(); // use push/popMatrix so each Shape's translation/rotation does not affect other drawings
  }

  // randomly sets the xy position of the shape as a whole and the colors of the shape  
  void reset() {
    x = random(-2*width, 3*width); // set the x position
    y = random(-height, 2*height); // set the y position
    c[0] = color(random(150, 255), random(150, 255), random(150, 255)); // set the top color (a bit lighter)
    // randomly set the 4 colors in the base of the shape
    for (int i=1; i<5; i++) {
      c[i] = color(random(255), random(255), random(255)); // random RGB color
    }
  }
}

