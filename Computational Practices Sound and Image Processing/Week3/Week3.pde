// Ukiyo-e Inspired Wave
void setup() {size(1200, 850);smooth();noLoop();}

//background
void draw() {background(238, 222, 190); 
//background lines
drawSeaLines();
//let sun cover
drawRedSun();

// small back wave
pushMatrix();
//Position
translate(760, 470);
//Reduce scale
scale(0.9);
//Rotate
rotate(radians(-3));
drawWave();
//right wave
popMatrix();

// middle wave copy last
pushMatrix();
//Position
translate(500, 560);
scale(1.1);
rotate(radians(4));
drawWave();
popMatrix();

// main large front wave
pushMatrix();
translate(140, 650);
scale(1.6, 1.3);
rotate(radians(-2));
drawWave();
popMatrix();

// right front wave
pushMatrix();
translate(770, 680);
scale(1.2, 1.0);
rotate(radians(2));
drawWave();
popMatrix();

//water lines
drawBottomLines();}

void drawWave() {
//Cancel border
noStroke();
// main dark blue
fill(24, 63, 120);
//Main body of the waves
beginShape();
vertex(0, 80);
//first point
//Bézier curve
//An arc rising from left to right
bezierVertex(40, 40, 100, 10, 160, 0);
//Let the waves rise upward.
bezierVertex(250, -20, 290, -120, 240, -190);
//Paint the curled tip of the wave at the top.
bezierVertex(210, -240, 140, -240, 100, -200);
//Let the crest of the wave roll back inward.
bezierVertex(140, -190, 180, -160, 170, -120);
//Draw the part of the waves that falls downward inside.
bezierVertex(160, -80, 120, -60, 80, -50);
//Let the waves spread to the right, forming width.
bezierVertex(150, -30, 240, -10, 340, 30);
//Go from the right back to the bottom, closing the entire shape.
bezierVertex(270, 60, 150, 95, 0, 80);
endShape(CLOSE);

//inside shape
fill(70, 130, 180);
beginShape();
vertex(40, 60);
bezierVertex(90, 30, 140, 15, 180, -5);
bezierVertex(220, -25, 235, -70, 205, -120);
bezierVertex(180, -150, 140, -145, 115, -120);
bezierVertex(140, -110, 155, -85, 145, -60);
bezierVertex(130, -35, 90, -20, 60, -10);
bezierVertex(120, 5, 190, 20, 260, 45);
bezierVertex(200, 58, 110, 65, 40, 60);
endShape(CLOSE);

// foam
drawFoam();

// inner lines
drawWaveLines();}
//details
void drawFoam() {
fill(250, 244, 225);
noStroke();

//top foam dots
  for (int i = 0; i < 12; i++) 
//Repeat 12 times, draw 12 bubbles.
{float x = 95 + i * 12;
    float y = -195 + sin(radians(i * 30)) * 18;
    float s = 10 + (i % 3) * 4;   
ellipse(x, y, s, s);}

// inner foam dots
for (int i = 0; i < 8; i++) {
float x = 110 + i * 18;
float y = -135 + (i % 2) * 15;  // modulo changes height
ellipse(x, y, 8, 8); }

// flying drops
//Even-numbered bubbles are on top
//Odd-numbered bubbles move down a little
for (int i = 0; i < 9; i++) {
float x = 210 + i * 18;
float y = -70 + (i % 2) * 15;

if (i % 3 == 0) {ellipse(x, y, 10, 10);} 
//tiangle water
else {triangle(x, y - 5, x - 5, y + 5, x + 5, y + 5);}
  }
}
// inside wave
void drawWaveLines() {
noFill();
stroke(238, 222, 190, 180);
strokeWeight(1.2);

for (int i = 0; i < 6; i++) {
float offset = i * 18;

beginShape();
vertex(40 + offset, 65);
bezierVertex(80 + offset, 30, 120 + offset, -10, 145 + offset, -70);
bezierVertex(155 + offset, -95, 140 + offset, -120, 115 + offset, -115);
endShape();
  }
}
// background lines
//Layer upon layer of water ripple lines
void drawSeaLines() {
  noFill();
  stroke(60, 110, 150, 120);
  strokeWeight(1.4);
//Draw a line every 22 pixels from the top of the canvas to near the bottom.
for (int y = 30; y < height - 80; y += 22) {
    beginShape();

for (int x = -40; x <= width + 40; x += 35) {
      float offset = sin(radians(x * 0.8 + y)) * 7;
//The line has ups and downs
curveVertex(x, y + offset);
    }
endShape();
  }
}
// bottom water lines
//Deeper water ripples
void drawBottomLines() {
  noFill();
  stroke(20, 55, 100, 150);
  strokeWeight(2);


//Draw a line within a 90-pixel range
for (int y = height - 90; y < height; y += 18) {
    beginShape();

//Sense of weight
for (int x = -40; x <= width + 40; x += 40) {
      float offset = sin(radians(x + y * 2)) * 8;
      curveVertex(x, y + offset);
    }

endShape();
  }
}
// red sun
void drawRedSun() {
  noStroke();
  fill(190, 55, 35);
// moved higher so it does not touch the waves
  ellipse(1030, 100, 130, 130);
}
