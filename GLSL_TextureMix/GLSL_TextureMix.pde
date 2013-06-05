
/*

 GLSL Texture Mix by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 Creating a smooth mix between multiple textures in the fragment shader.
 
 MOUSE PRESS = toggle between three mix types (Subtle, Regular, Obvious)
 
 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final
 
 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.
 
*/

PShader textureMix; // PShader that - given it's content - can be applied to textured geometry
PImage[] images = new PImage[3]; // array to hold 3 images
int mixType; // variable to set the current mixType
int maxTypes = 3; // variable used to keep the sketch within the maximum number of types (defined in the shader)

void setup() {
  size(1150, 850, P2D); // use the P2D OpenGL renderer

  // load the images from the _Images folder (relative path from this sketch's folder) into the GLTexture array
  images[0] = loadImage("../_Images/Texture01.jpg");
  images[1] = loadImage("../_Images/Texture02.jpg");
  images[2] = loadImage("../_Images/Texture03.jpg");

  // load the PShader with a fragment and a vertex shader
  textureMix = loadShader("textureMixFrag.glsl", "textureMixVert.glsl");

  // set the images as respective textures for the fragment shader
  textureMix.set("tex0", images[0]);
  textureMix.set("tex1", images[1]);
  textureMix.set("tex2", images[2]);
}

void draw() {
  background(0); // black background

  textureMix.set("mixType", mixType); // set the mixType
  textureMix.set("time", millis()/5000.0); // feed time to the PShader
  shader(textureMix); // apply the shader to subsequent textured geometry
  image(images[0], 0, 0, 850, 850); // display any image as a 'textured geometry canvas' for the PShader
  resetShader(); // reset to the default shader for subsequent geometry 
  
  // display the 3 original images on the right
  for (int i=0; i<images.length; i++) {
    pushMatrix();
    translate(875, 25+i*275); // set the position
    image(images[i], 0, 0, 250, 250); // display the image in thumbnail style (250x250)
    popMatrix();
  }

  // write the fps and the current mixType (in words through some ?: trickery) in the top-left of the window
  frame.setTitle(" " + int(frameRate) + " | mixType: " + (mixType==0?"Subtle":mixType==1?"Regular":"Obvious"));
}

void mousePressed() {
  mixType = ++mixType%maxTypes; // cycle trough mixTypes
}

