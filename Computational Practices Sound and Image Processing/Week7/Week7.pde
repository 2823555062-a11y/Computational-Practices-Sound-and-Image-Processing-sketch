import processing.sound.*;

//Three sound
//Square wave oscillator
SqrOsc lead;      
//Sawtooth wave oscillator
SawOsc bass;      
PinkNoise noise;   
//Low-pass filter
LowPass filter; 


Sound sound;
//Main melody note array
float[] melody = {
523, 659, 784, 659,
523, 392, 440, 523};

//Bass note array
float[] bassNotes = {
130, 130, 196, 196};

//Record which note is currently being played
int melodyNumber = 0;
int bassNumber = 0;

//Variable that controls volume
float leadVolume = 0;
float bassVolume = 0;

float leadFreq = 523;
float bassFreq = 130;

//Planet size variable
float planetSize = 160;

void setup() {
size(700, 600);

//Overall volume
sound = new Sound(this);
sound.volume(0.4);

//Create the sounds
lead = new SqrOsc(this);
bass = new SawOsc(this);
noise = new PinkNoise(this);
filter = new LowPass(this);

//Put the noise through the filter
filter.process(noise);

//Start sounds
lead.play();
bass.play();
noise.play();

//Start
lead.amp(0);
bass.amp(0);
noise.amp(0.04);}

void draw() {background(10, 10, 30);

//Change
makeSound();

//Picture
drawPlanet();}

//Frequency Modulation
void makeSound() {
float move = sin(frameCount * 0.15) * 8;
lead.freq(leadFreq + move);

//Play melody every 12 frames
if (frameCount % 12 == 0) {
leadFreq = melody[melodyNumber];
leadVolume = 0.2;

//Next
melodyNumber = melodyNumber + 1;

//If the melody finishes playing, start from the beginning
if (melodyNumber >= melody.length) {melodyNumber = 0;}

//Make the planet a bit bigger
planetSize = 190;}

//Play bass every 24 frames
if (frameCount % 24 == 0) {
bassFreq = bassNotes[bassNumber];
bassVolume = 0.12;

//Next
bassNumber = bassNumber + 1;
if (bassNumber >= bassNotes.length) {bassNumber = 0;}
}

//Set bass frequency
  bass.freq(bassFreq);

//Set volume
lead.amp(leadVolume);
bass.amp(bassVolume);

//Let the sound slowly fade away
leadVolume = leadVolume * 0.82;
bassVolume = bassVolume * 0.90;

//Change the filter slowly
float filterFreq = map(sin(frameCount * 0.02), -1, 1, 400, 2500);
filter.freq(filterFreq);
}

void drawPlanet() {
planetSize = planetSize * 0.92 + 160 * 0.08;

//Title
fill(255);
textSize(18);
text("Video Game Planet Landing Sound", 30, 35);
textSize(13);
text("Square wave melody + Saw wave bass + Pink noise with filter", 30, 58);

//Stars
fill(255);
for (int i = 0; i < 30; i++) {
float x = (i * 70) % width;
float y = (i * 43) % height;
rect(x, y, 3, 3);}

noStroke();
fill(40, 80, 200, 80);
ellipse(width / 2, height / 2, planetSize + 70, planetSize + 70);

//Planet
fill(70, 180, 220);
ellipse(width / 2, height / 2, planetSize, planetSize);

//Pixel blocks
fill(20, 100, 160);
rect(width / 2 - 50, height / 2 + 20, 35, 20);
rect(width / 2 + 10, height / 2 + 35, 45, 20);
rect(width / 2 - 15, height / 2 - 35, 30, 20);

// volume bars
fill(255);
textSize(14);
text("Lead", 80, height - 80);
text("Bass", 80, height - 50);
text("Noise", 80, height - 20);
rect(140, height - 92, leadVolume * 800, 15);
rect(140, height - 62, bassVolume * 800, 15);
rect(140, height - 32, 40, 15);}
