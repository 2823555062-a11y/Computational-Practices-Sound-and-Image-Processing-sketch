PImage sample;
void setup() {
  size(1000, 1000);
  sample = loadImage("picture1.jpg");
  sample.resize(550,0);
}
void draw() {
background(255);
//place picture mid
int imageX = (width - sample.width) / 2;
image(sample, imageX, 0);
//Read image pixels
 sample.loadPixels();
 //creative three histograms
int[] redHistogram = new int[256];
int[] greenHistogram = new int[256];
int[] blueHistogram = new int[256];

// Go through
  for (int i = 0; i < sample.pixels.length; i++) {

    color c = sample.pixels[i];
 int r = int(red(c));
 int g = int(green(c));
 int b = int(blue(c));

// Add RGB
    redHistogram[r]++;
    greenHistogram[g]++;
    blueHistogram[b]++;
  }

// Positions
  int redBase = sample.height + 80;
  int greenBase = sample.height + 160;
  int blueBase = sample.height + 250;
int histHeight = 60;
 // Draw red histogram
  for (int i = 0; i < redHistogram.length; i++) {
    stroke(255, 0, 0);
    float x = map(i, 0, 255, 0, width);
    float startHeight = map(redHistogram[i], 0, max(redHistogram), redBase, redBase - histHeight);
    line(x, startHeight, x, redBase);
  }
// Draw green histogram
  for (int i = 0; i < greenHistogram.length; i++) {
    stroke(0, 180, 0);
    float x = map(i, 0, 255, 0, width);
    float startHeight = map(greenHistogram[i], 0, max(greenHistogram), greenBase, greenBase - histHeight);
    line(x, startHeight, x, greenBase);
  }
 // Draw blue histogram
  for (int i = 0; i < blueHistogram.length; i++) {
    stroke(0, 0, 255);
    float x = map(i, 0, 255, 0, width);
    float startHeight = map(blueHistogram[i], 0, max(blueHistogram), blueBase, blueBase - histHeight);
    line(x, startHeight, x, blueBase);
  }
}
