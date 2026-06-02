// Noise Wave Scene
//Control animation changes
float time = 0;
//use mouse control
float waveMove = 0;
//Canvas
void setup() {
  size(800, 650);
  smooth();
}
//background
void draw() {
//colour
background(235, 226, 200);

//left or right controls wave direction
float mouseDirection = mouseX - pmouseX;
//Let the waves move a little slower
waveMove = waveMove + mouseDirection * 0.008;

//Draw background wavy lines; draw the sun; draw three layers of waves; draw white foam lines
drawBackgroundLines();
drawSun();
drawWaves();
drawFoam();

time = time + 0.01; 
}

// draw red sun
void drawSun() {noStroke();fill(190, 40, 30);ellipse(640, 120, 150, 150);}

//background lines
void drawBackgroundLines() {noFill();stroke(40, 70, 120, 55);strokeWeight(1);

// smaller denser
for (int y = 15; y < height; y += 14) {
//Draw a custom line
    beginShape();

for (int x = 0; x <= width; x += 8) {
// main shape
float waveLine = sin(x * 0.045 + time * 1.8 + y * 0.03) * 12;

// small noise
float n = noise(x * 0.01, y * 0.02, time * 0.5);
float noiseLine = map(n, 0, 1, -4, 4);
vertex(x, y + waveLine + noiseLine);}

endShape();
  }
}

// draw three waves
void drawWaves() {
// blue wave
noStroke();
fill(20, 70, 130);

beginShape();
vertex(0, height);

//Generate the top of the waves using noise
for (int x = 0; x <= width; x += 15) {
    float n = noise(x * 0.008 - waveMove, time * 0.5);
    float y = map(n, 0, 1, 400, 500);
    vertex(x, y);
  }
  
//Closed shape
vertex(width, height);
  endShape(CLOSE);

// middle blue wave
fill(40, 120, 180, 190);

beginShape();
vertex(0, height);

for (int x = 0; x <= width; x += 15) {
    float n = noise(x * 0.01 - waveMove + 50, time * 0.5);

float y = map(n, 0, 1, 400, 600);
    vertex(x, y);
  }

  vertex(width, height);
  endShape(CLOSE);

  // light blue wave
  fill(120, 180, 210, 140);

  beginShape();
  vertex(0, height);

  for (int x = 0; x <= width; x += 15) {
    float n = noise(x * 0.012 - waveMove + 100, time * 0.5);
//Light blue, and more transparent
    float y = map(n, 0, 1, 400, 550);
    vertex(x, y);
  }

  vertex(width, height);
  endShape(CLOSE);
}

//broken white lines
void drawFoam() {
  noFill();
  stroke(245);
  strokeWeight(4);

  for (int x = 20; x < width; x += 80) {
    beginShape();

//The first layer of waves
for (int i = 0; i < 50; i += 10) {
      float px = x + i;

//same noise
float n = noise(px * 0.008 - waveMove, time * 0.5);
float py = map(n, 0, 1, 300, 470);

vertex(px, py + 15);
    }

endShape();
  }

// smaller foam lines
strokeWeight(2);
for (int x = 60; x < width; x += 90) {
beginShape();
for (int i = 0; i < 40; i += 10) {
float px = x + i;
float n = noise(px * 0.01 - waveMove + 50, time * 0.5);
float py = map(n, 0, 1, 360, 520);

      vertex(px, py + 10);
    }

    endShape();
  }
}
