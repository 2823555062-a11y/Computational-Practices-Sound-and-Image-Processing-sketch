import processing.video.*;

Capture cam;

PImage filteredImage;
PImage ditherImage;

int camW = 320;
int camH = 240;

int version = 1;
int savedCount = 0;

boolean useConvolution = true;

float[][] sharpen = {
{0, -1, 0},
{-1, 5, -1},
{0, -1, 0}
};

void setup() {
size(640, 480);
pixelDensity(1);

String[] cameras = Capture.list();

if (cameras.length == 0) {
println("No camera found.");
exit();
} else {
println("Available cameras:");
for (int i = 0; i < cameras.length; i++) {
println(i + ": " + cameras[i]);
}

cam = new Capture(this, camW, camH, cameras[0], 30);
cam.start();
}
}

void draw() {
background(0);

if (cam.available()) {
cam.read();
}

if (useConvolution) {
filteredImage = convolveCamera(cam, sharpen);
} else {
filteredImage = copyToGrey(cam);
}

ditherImage = floydSteinbergDither(filteredImage);

image(ditherImage, 0, 0, width, height);

drawComicFrame();
drawText();
}

PImage copyToGrey(PImage input) {
PImage output = createImage(input.width, input.height, RGB);

input.loadPixels();
output.loadPixels();

for (int i = 0; i < input.pixels.length; i++) {
color c = input.pixels[i];

float r = red(c);
float g = green(c);
float b = blue(c);

float grey = r * 0.299 + g * 0.587 + b * 0.114;

output.pixels[i] = color(grey);
}

output.updatePixels();
return output;
}

PImage convolveCamera(PImage input, float[][] kernel) {
PImage output = createImage(input.width, input.height, RGB);

input.loadPixels();
output.loadPixels();

for (int y = 0; y < input.height; y++) {
for (int x = 0; x < input.width; x++) {
float sumR = 0;
float sumG = 0;
float sumB = 0;

for (int offsetY = -1; offsetY <= 1; offsetY++) {
for (int offsetX = -1; offsetX <= 1; offsetX++) {
int neighbourX = constrain(x + offsetX, 0, input.width - 1);
int neighbourY = constrain(y + offsetY, 0, input.height - 1);

int neighbourIndex = neighbourY * input.width + neighbourX;

color c = input.pixels[neighbourIndex];

float r = red(c);
float g = green(c);
float b = blue(c);

float amount = kernel[offsetY + 1][offsetX + 1];

sumR += r * amount;
sumG += g * amount;
sumB += b * amount;
}
}

sumR = constrain(sumR, 0, 255);
sumG = constrain(sumG, 0, 255);
sumB = constrain(sumB, 0, 255);

float grey = sumR * 0.299 + sumG * 0.587 + sumB * 0.114;

if (version == 2) {
grey = grey * 1.25 - 25;
}

if (version == 3) {
grey = 255 - grey;
}

grey = constrain(grey, 0, 255);

int index = y * input.width + x;
output.pixels[index] = color(grey);
}
}

output.updatePixels();
return output;
}

PImage floydSteinbergDither(PImage input) {
PImage output = createImage(input.width, input.height, RGB);

input.loadPixels();
output.loadPixels();

float[] grey = new float[input.pixels.length];

for (int i = 0; i < input.pixels.length; i++) {
grey[i] = red(input.pixels[i]);
}

for (int y = 0; y < input.height - 1; y++) {
for (int x = 1; x < input.width - 1; x++) {
int index = y * input.width + x;

float oldPixel = grey[index];
float newPixel;

if (oldPixel > 127) {
newPixel = 255;
} else {
newPixel = 0;
}

float error = oldPixel - newPixel;

grey[index] = newPixel;

grey[index + 1] += error * 7 / 16.0;
grey[index + input.width - 1] += error * 3 / 16.0;
grey[index + input.width] += error * 5 / 16.0;
grey[index + input.width + 1] += error * 1 / 16.0;
}
}

color darkColour = color(18, 24, 26);
color lightColour = color(190, 210, 210);

if (version == 2) {
darkColour = color(35, 30, 25);
lightColour = color(220, 210, 180);
}

if (version == 3) {
darkColour = color(0);
lightColour = color(245);
}

for (int i = 0; i < grey.length; i++) {
if (grey[i] > 127) {
output.pixels[i] = lightColour;
} else {
output.pixels[i] = darkColour;
}
}

output.updatePixels();
return output;
}

void drawComicFrame() {
noFill();

stroke(255);
strokeWeight(18);
rect(0, 0, width, height);

stroke(0);
strokeWeight(4);
rect(18, 18, width - 36, height - 36);
}

void drawText() {
fill(0, 160);
noStroke();
rect(20, height - 58, 430, 40);

fill(255);
textSize(14);
text("1/2/3 = change style    F = filter on/off    S = save frame", 30, height - 35);
text("Saved frames: " + savedCount + "/10", 30, height - 17);
}

void keyPressed() {
if (key == '1') {
version = 1;
}

if (key == '2') {
version = 2;
}

if (key == '3') {
version = 3;
}

if (key == 'f' || key == 'F') {
useConvolution = !useConvolution;
}

if (key == 's' || key == 'S') {
if (savedCount < 10) {
saveFrame("comic-frame-######.jpg");
savedCount++;
println("Saved frame " + savedCount);
} else {
println("You already saved 10 frames.");
}
}
}
