//Horizontal Gradient
//background
void setup() {size(500, 500);}
//Colour:Blue,Purple,Cyan,White
void draw() {
loadPixels();
color midnightBlue = color(13, 20, 42);
color lavenderPurple = color(180, 170, 240);
color neonCyan = color(40, 190, 200);
color softWhite = color(230, 240, 200);
//Check every pixel on the canvas
for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {float t = map(x, 0, width - 1, 0, 1);
//Create a color variable called 
color c;

//blue to purple
if (t < 0.33) {
        float localT = map(t, 0, 0.33, 0, 1);
        c = lerpColor(midnightBlue, lavenderPurple, localT); }
//purple to ice blue
else if (t < 0.66) {float localT = map(t, 0.33, 0.66, 0, 1);
        c = lerpColor(lavenderPurple, neonCyan, localT);}
//Cyan to White 
else {float localT = map(t, 0.66, 1, 0, 1);
        c = lerpColor(neonCyan, softWhite, localT);}
//Put the color into the current pixel
pixels[x + y * width] = c;}
  }
updatePixels();
}
