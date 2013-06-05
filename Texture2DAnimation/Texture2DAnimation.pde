
/*

 Texture 2D Animation by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating an animation by using texture coordinates to read from a spritesheet.
 An individual offset can be used to differentiate the current frame for each instance.
 
 MOUSE MOVE = change the scale of individual instances based on the distance from the mouse
              (note that a negative scale is possible, this will scale AND invert the shape!)

 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final

 Spritesheet created by Amnon Owed using Illustrator's blend mode... not recommended! ;-)

 If you make something awesome, based on this sketch, please let me know via twitter @AmnonOwed
  
*/

PImage spritesheet; // the image that holds the spritesheet animation
int DIM = 6; // the horizontal and vertical dimensions of the spritesheet grid (important! get this wrong and it'll all fall down to pieces)
int NUMSHAPES = 300; // the number of shapes to draw on the canvas
float W = 1.0/DIM; // calculate the normalized width of one cell in the spritesheet grid
float H = 1.0/DIM; // calculate the normalized height of one cell in the spritesheet grid

void setup() {
  size(1280, 720, P2D); // use the P2D OpenGL renderer
  spritesheet = loadImage("animation.png"); // load the image (from the /data subdirectory)
  textureMode(NORMAL); // use normalized (0 to 1) texture coordinates
  noStroke(); // turn off stroke (for the rest of the sketch)
  smooth(6); // set smooth level 6 (default is 2)
}

void draw() {
  // some calculations for the color gradient below
  int dmod = frameCount%510;
  int col = dmod<255?dmod:510-dmod;

  // create a continuous smooth dynamic color gradient covering the whole sketch window
  beginShape(); // default shapeMode
  // top color and vertices
  fill(255, col, 0);
  vertex(0, 0);
  vertex(width, 0);
  // bottom color and vertices
  fill(0, 255, 255-col);
  vertex(width, height);
  vertex(0, height);
  endShape(); // finalize the Shape

  // set a randomSeed() so the shapes are 'randomly' placed in the same place
  randomSeed(0);
  for (int i=0; i<NUMSHAPES; i++) {
    pushMatrix(); // use push/popMatrix so each Shape's translation/scale does not affect other drawings
    float px = random(width); // random x somewhere on the canvas
    float py = random(height); // random y somewhere on the canvas
    translate(px, py); // translate to xy
    scale(map(dist(px, py, mouseX, mouseY), 0, width/2, 150, 15)); // scale depending on the distance to the mouse
    int fi = frameCount+i; // starting cell based on number in the for loop, animation based on frameCount
    float x = fi%DIM*W; // get the x texture coordinate of the cell
    float y = fi/DIM%DIM*H; // get the y texture coordinate of the cell
    beginShape(); // default shapeMode
    texture(spritesheet); // set the spritesheet texture
    // set the 4 vertices of this Shape with unit length (it's scaled a couple of lines back remember)
    // use the calculated texture coordinates plus the global normalized width and height of each cell
    vertex(0, 0, x, y);
    vertex(1, 0, x+W, y);
    vertex(1, 1, x+W, y+H);
    vertex(0, 1, x, y+H);
    endShape(); // finalize the Shape
    popMatrix(); // use push/popMatrix so each Shape's translation/scale does not affect other drawings
  }

  // write the fps in the top-left of the window
  frame.setTitle(int(frameRate) + " fps");
}

