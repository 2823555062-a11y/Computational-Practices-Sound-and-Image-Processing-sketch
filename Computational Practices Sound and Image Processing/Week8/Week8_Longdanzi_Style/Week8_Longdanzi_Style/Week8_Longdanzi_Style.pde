import processing.sound.*;

// Week 8 - Algorithmic Music and Sampling
// Original dark old-school hip-hop intro style.
// It uses samples, frameCount and the modulo operator.

SoundFile kick;
SoundFile snare;
SoundFile hihat;
SoundFile clap;
SoundFile atmosphere;

// Slow tempo for a darker intro feeling
int bpm = 86;
int fps = 60;

// One step is half a beat.
// This makes a 16-step drum pattern.
int framesPerStep;

// Visual variables
float kickSize = 0;
float snareSize = 0;
float hatLine = 0;
float clapFlash = 0;

int lastStep = -1;

void setup() {
  size(640, 360);
  frameRate(fps);

  framesPerStep = int((60.0 / bpm) * fps / 2.0);

  // Load samples from the data folder
  kick = new SoundFile(this, "kick.wav");
  snare = new SoundFile(this, "snare.wav");
  hihat = new SoundFile(this, "hihat.wav");
  clap = new SoundFile(this, "clap.wav");
  atmosphere = new SoundFile(this, "atmosphere.wav");

  // Set volumes
  kick.amp(0.9);
  snare.amp(0.7);
  hihat.amp(0.45);
  clap.amp(0.55);
  atmosphere.amp(0.35);

  // The atmosphere sample loops in the background
  atmosphere.loop();
}

void draw() {
  background(18, 12, 25);

  int step = (frameCount / framesPerStep) % 16;
  int bar = frameCount / (framesPerStep * 8);

  // Only trigger sounds when the step changes
  if (step != lastStep) {
    playBeat(step, bar);
    lastStep = step;
  }

  drawVisuals(step, bar);

  // Fade the visual reactions
  kickSize = kickSize * 0.88;
  snareSize = snareSize * 0.88;
  hatLine = hatLine * 0.82;
  clapFlash = clapFlash * 0.86;
}

void playBeat(int step, int bar) {

  // First two bars are more empty, like an intro
  boolean introPart = bar < 2;

  // Kick pattern
  if (step == 0 || step == 7) {
    kick.play();
    kickSize = 150;
  }

  // Add one extra kick after the intro
  if (!introPart && step == 10) {
    kick.play();
    kickSize = 120;
  }

  // Snare on the backbeat
  if (step == 4 || step == 12) {
    snare.play();
    snareSize = 120;
  }

  // Hi-hat uses modulo and randomness
  if (step % 2 == 0) {
    if (random(1) < 0.8) {
      hihat.play();
      hatLine = 140;
    }
  }

  // Extra small hat before the snare
  if (!introPart && (step == 3 || step == 11)) {
    if (random(1) < 0.45) {
      hihat.play();
      hatLine = 90;
    }
  }

  // Clap only appears every second bar
  if (bar % 2 == 1 && step == 12) {
    clap.play();
    clapFlash = 140;
  }

  // Small fill every fourth bar
  if (bar % 4 == 3 && step == 15) {
    if (random(1) < 0.7) {
      snare.play();
      clap.play();
      snareSize = 170;
      clapFlash = 180;
    }
  }
}

void drawVisuals(int step, int bar) {
  noStroke();

  // Clap flash
  fill(120, 70, 160, clapFlash);
  rect(0, 0, width, height);

  // Dark circle for kick
  fill(80, 40, 130, 170);
  circle(width / 2, height / 2, kickSize);

  // Snare circle
  fill(180, 120, 200, 150);
  circle(width / 2, height / 2, snareSize);

  // Hi-hat line
  stroke(230, 220, 255, 180);
  strokeWeight(2);
  line(width / 2 - hatLine, height / 2 + 95, width / 2 + hatLine, height / 2 + 95);

  // A simple 16-step grid
  noStroke();
  for (int i = 0; i < 16; i++) {
    if (i == step) {
      fill(255, 230, 120);
    } else if (i % 4 == 0) {
      fill(100, 80, 130);
    } else {
      fill(55, 45, 70);
    }

    rect(58 + i * 33, 300, 22, 22);
  }

  // Text
  fill(240);
  textSize(16);
  text("Week 8 - Dark Intro Drum Pattern", 28, 35);
  text("Samples: kick / snare / hihat / clap / atmosphere", 28, 58);
  text("BPM: " + bpm + "    Step: " + step + "    Bar: " + bar, 28, 82);
}