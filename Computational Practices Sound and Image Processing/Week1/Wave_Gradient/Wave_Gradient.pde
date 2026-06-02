//Wave Gradient
//This sketch creates a wave-like gradient using sine values
void setup() {
  size(500, 500);
}
//Colour: Blue, Purple, Cyan, White
void draw() {
loadPixels();
color midnightBlue = color(13, 20, 42);
color lavenderPurple = color(180, 170, 240);
color neonCyan = color(40, 190, 200);
color softWhite = color(230, 240, 200);
//Check pixel on the canvas
for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
//Use sine to create a repeating wave pattern based on x and y position
float wave = sin(x * 0.03 + y * 0.025);
//value from -1 to 1 into a 0 to 1 colour range
float t = map(wave, -1, 1, 0, 1);

//Create a color variable called c
color c;
//Blue to purple
if (t < 0.33) {
float localT = map(t, 0, 0.33, 0, 1);
//Blend smoothly between blue and purple
c = lerpColor(midnightBlue, lavenderPurple, localT);
}
//Purple to cyan
else if (t < 0.66) {float localT = map(t, 0.33, 0.66, 0, 1);
//Blend smoothly between purple and cyan
c = lerpColor(lavenderPurple, neonCyan, localT);}
//Cyan to white
else {float localT = map(t, 0.66, 1, 0, 1);
//Blend smoothly between cyan and white
c = lerpColor(neonCyan, softWhite, localT);}

pixels[x + y * width] = c;}
  }
  updatePixels();
}
