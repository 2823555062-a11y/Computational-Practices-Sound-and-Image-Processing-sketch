//Vertical Gradient
//background
void setup() {size(500, 500);}
//Colour: Blue, Purple, Cyan, White
void draw() {
  loadPixels();
color midnightBlue = color(13, 20, 42);
color lavenderPurple = color(180, 170, 240);
color neonCyan = color(40, 190, 200);
color softWhite = color(230, 240, 200);
 //Check every pixel on the canvas
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      float t = map(y, 0, height - 1, 0, 1);
//Create a color variable called c
color c;
//white to cyan
if (t < 0.33) {float localT = map(t, 0, 0.33, 0, 1);
c = lerpColor(softWhite, neonCyan, localT);}
//cyan to purple
else if (t < 0.66) {float localT = map(t, 0.33, 0.66, 0, 1);
c = lerpColor(neonCyan, lavenderPurple, localT);}
//purple to blue
else {float localT = map(t, 0.66, 1, 0, 1);
c = lerpColor(lavenderPurple, midnightBlue, localT);}
//Put the color into the current pixel
      pixels[x + y * width] = c;}
  }
updatePixels();
}
