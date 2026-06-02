import processing.sound.*;

SoundFile kick;
SoundFile snare;
SoundFile hihat;
SoundFile clap;
SoundFile atmosphere;

int framesPerStep = 21;
int lastStep = -1;

float kickSize = 0;
float snareSize = 0;
float hatSize = 0;
float flash = 0;

void setup() {
size(640, 360);
frameRate(60);

kick = new SoundFile(this, "kick.wav");
snare = new SoundFile(this, "snare.wav");
hihat = new SoundFile(this, "hihat.wav");
clap = new SoundFile(this, "clap.wav");
atmosphere = new SoundFile(this, "atmosphere.wav");

kick.amp(0.9);
snare.amp(0.7);
hihat.amp(0.4);
clap.amp(0.5);
atmosphere.amp(0.3);

atmosphere.loop();
}

void draw() {
background(18, 12, 25);

int step = (frameCount / framesPerStep) % 16;
int bar = frameCount / (framesPerStep * 16);

if (step != lastStep) {

if (step == 0 || step == 7) {
kick.play();
kickSize = 150;
}

if (bar > 1 && step == 10) {
kick.play();
kickSize = 110;
}

if (step == 4 || step == 12) {
snare.play();
snareSize = 120;
}

if (step % 2 == 0) {
if (random(1) < 0.8) {
hihat.play();
hatSize = 130;
}
}

if (bar > 1 && step == 3) {
if (random(1) < 0.5) {
hihat.play();
hatSize = 80;
}
}

if (bar % 2 == 1 && step == 12) {
clap.play();
flash = 130;
}

if (bar % 4 == 3 && step == 15) {
if (random(1) < 0.7) {
snare.play();
clap.play();
snareSize = 160;
flash = 160;
}
}

lastStep = step;
}

noStroke();

fill(120, 70, 160, flash);
rect(0, 0, width, height);

fill(80, 40, 130, 170);
circle(width / 2, height / 2, kickSize);

fill(180, 120, 200, 150);
circle(width / 2, height / 2, snareSize);

stroke(230, 220, 255);
strokeWeight(2);
line(width / 2 - hatSize, height / 2 + 95, width / 2 + hatSize, height / 2 + 95);

noStroke();

for (int i = 0; i < 16; i++) {
if (i == step) {
fill(255, 230, 120);
} else {
fill(60, 50, 80);
}

rect(58 + i * 33, 300, 22, 22);
}

fill(240);
textSize(16);
text("Week 8 Drum Pattern", 28, 35);
text("step: " + step + "   bar: " + bar, 28, 60);

kickSize = kickSize * 0.88;
snareSize = snareSize * 0.88;
hatSize = hatSize * 0.82;
flash = flash * 0.86;
}
