//Main target
Worm worm;
Food food;
Bird bird;

int score = 0;
//Target Score
int targetScore = 6;
float energy = 100;
//Switch variable
boolean leftPressed = false;
boolean rightPressed = false;
boolean enterPressed = false;
boolean gameOver = false;
boolean win = false;

//Array used for falling petals
float[] petalX = new float[80];
float[] petalY = new float[80];
float[] petalSpeed = new float[80];
float[] petalSize = new float[80];

void setup() {
  size(1000, 800);
//Initialize game content
//The purpose is to restart the game by pressing R
resetGame();}

void resetGame() {
//Place the worm back in the center of the screen
worm = new Worm(width / 2, height / 2);
//Create a new four-leaf clover
food = new Food();
//Place the bird near the upper left corner
bird = new Bird(80, 80);

//Reset the score to zero
score = 0;
//Restore energy to 100
energy = 100;
//Clear the game over state
gameOver = false;
win = false;
//Regenerate the positions of the petals
makePetals();}

//Call the soil lines in the background of the drawing
void draw() {
background(225, 205, 170);
drawSoil();

//If you have already won or lost, the worm and the bird will not continue to move.
if (!gameOver) {PVector soilWind = new PVector(0.02 * sin(frameCount * 0.03), 0);
worm.applyForce(soilWind);
worm.update();
bird.update(worm.position);

//If the player holds down Enter to make the worm move forward, energy will decrease faster
energy -= 0.02;
if (enterPressed) {energy -= 0.08;}

//Check whether the earthworm has eaten the four-leaf clover
if (PVector.dist(worm.position, food.position) < 25) {
score++;
energy = min(100, energy + 15);
food.randomise();}

// Check if the bird has caught an earthworm
if (PVector.dist(worm.position, bird.position) < 35) {
gameOver = true;
win = false;}

// energy runs out
if (energy <= 0) {energy = 0;
gameOver = true;
win = false;}

// win
if (score >= targetScore) {
gameOver = true;
win = true;}
  }

//The things on the screen
food.display();
worm.display();
bird.display();

drawUI();

//Game over, display the end screen
if (gameOver) {
drawEndScreen();

//Win
if (win) {drawPetals();}
  }
}

//Soil lines
void drawSoil() {
  stroke(190, 165, 130);
  strokeWeight(1);
for (int y = 40; y < height; y += 35) {
float wave = sin(frameCount * 0.01 + y * 0.1) * 5;
line(0, y + wave, width, y + wave);
  }
}

//Game interface text
void drawUI() {
fill(40);
textSize(18);
textAlign(LEFT);
text("Luck: " + score + " / " + targetScore, 20, 30);
text("Energy", 20, 60);

//energy
noFill();
stroke(40);
rect(90, 45, 150, 18);
noStroke();
fill(90, 160, 70);
rect(90, 45, energy * 1.5, 18);

//rightside 
// gold instruction text
fill(220, 170, 40);
textSize(14);
textAlign(RIGHT);

//Explanation
text("A / D or LEFT / RIGHT = bend body", width - 20, height - 50);
text("ENTER = move forward     R = restart", width - 20, height - 30);}

//Victory / Defeat Screen
void drawEndScreen() {
fill(0, 150);
rect(0, 0, width, height);
textAlign(CENTER);
textSize(42);

//If the player wins, display the victory text
if (win) {
fill(255, 230, 180);
text("YOU WIN!", width / 2, height / 2 - 30);
textSize(20);
fill(255);
text("The worm collected enough luck.", width / 2, height / 2 + 15);
  }
//If the player fails, display the failure text
else {
fill(255, 120, 120);
text("GAME OVER", width / 2, height / 2 - 30);

//Reason for failure
textSize(20);
fill(255);
text("The bird caught you or your energy ran out.", width / 2, height / 2 + 15);}
textSize(18);
fill(255);

text("Press R to restart", width / 2, height / 2 + 60);}

//Generate petals
void makePetals() {
for (int i = 0; i < petalX.length; i++) {
//Random attribute
petalX[i] = random(width);
petalY[i] = random(-600, 0);
petalSpeed[i] = random(1, 3);
petalSize[i] = random(6, 14);}
}

//Petal animation
void drawPetals() {
noStroke();
for (int i = 0; i < petalX.length; i++) {
fill(255, 170, 200, 180);
ellipse(petalX[i], petalY[i], petalSize[i], petalSize[i] * 0.6);

//Petals move
petalY[i] += petalSpeed[i];
petalX[i] += sin(frameCount * 0.03 + i) * 0.8;

//If a petal falls out of the bottom of the screen, put it back on top of the screen.
if (petalY[i] > height) {
petalY[i] = random(-100, 0);
petalX[i] = random(width);}
  }
}

//Control part
void keyPressed() {
if (key == 'r' || key == 'R') {
resetGame();}

if (key == 'a' || key == 'A' || keyCode == LEFT) {
leftPressed = true;}

if (key == 'd' || key == 'D' || keyCode == RIGHT) {
rightPressed = true;}

// Enter key
if (key == ENTER) {
enterPressed = true;}
}

//Key released
void keyReleased() {
if (key == 'a' || key == 'A' || keyCode == LEFT) {
leftPressed = false; }

if (key == 'd' || key == 'D' || keyCode == RIGHT) {
rightPressed = false;}

if (key == ENTER || key == RETURN) {
enterPressed = false;}
}

//The Core Usage of PVector
class Worm {
PVector position;
PVector velocity;
PVector acceleration;

PVector[] body;

//Head direction
float angle = 0;
//Distance between points
float spacing = 9;

//Constructor
Worm(float x, float y) {
position = new PVector(x, y);
velocity = new PVector(0, 0);
acceleration = new PVector(0, 0);
body = new PVector[25];
//The dots are arranged in order from left to right, forming a body
for (int i = 0; i < body.length; i++) {body[i] = new PVector(x - i * spacing, y);}
  }

void applyForce(PVector force) {acceleration.add(force);}

//If you press the left key, the angle decreases
//If you press the right key, the angle increases
void update() {
if (leftPressed) {angle -= 0.07;}
if (rightPressed) {angle += 0.07;}

//Calculate the forward direction based on the angle
if (enterPressed) {
PVector push = new PVector(cos(angle), sin(angle));
push.mult(0.22);
applyForce(push);}

//Friction
PVector friction = velocity.copy();
if (friction.mag() > 0) {
friction.normalize();
friction.mult(-0.04);
applyForce(friction);}

//Acceleration affects velocity
//Limits maximum speed
//Velocity affects position
velocity.add(acceleration);
velocity.limit(4);
position.add(velocity);

checkEdges();
body[0] = position.copy();

//Let the points on the back of the body follow the points in the front
for (int i = 1; i < body.length; i++) {
PVector direction = PVector.sub(body[i], body[i - 1]);
if (direction.mag() > spacing) {
direction.normalize();
direction.mult(spacing);
body[i] = PVector.add(body[i - 1], direction);}
}

//Clear acceleration
acceleration.mult(0);}

//Boundary Detection
void checkEdges() {
if (position.x < 10) {
position.x = 10;
velocity.x *= -0.5;}

if (position.x > width - 10) {
position.x = width - 10;
velocity.x *= -0.5;}

if (position.y < 10) {
position.y = 10;
velocity.y *= -0.5;}

if (position.y > height - 10) {
position.y = height - 10;
velocity.y *= -0.5;}
}

void display() {
noFill();

// worm body
stroke(95, 55, 35);
strokeWeight(10);
beginShape();
for (int i = 0; i < body.length; i++) {
vertex(body[i].x, body[i].y); }
endShape();
// light line
stroke(230, 170, 110);
strokeWeight(3);
beginShape();
for (int i = 0; i < body.length; i++) {
vertex(body[i].x, body[i].y); }
 endShape();
// head
noStroke();
fill(80, 45, 30);
circle(position.x, position.y, 18);
// eyes
fill(255);
circle(position.x + cos(angle - 0.5) * 8, position.y + sin(angle - 0.5) * 8, 5);
circle(position.x + cos(angle + 0.5) * 8, position.y + sin(angle + 0.5) * 8, 5); }
}
//Food
class Food {
PVector position;
//Appear randomly
Food() { randomise(); }

void randomise() {
//Will not appear too close to the edge
position = new PVector(random(60, width - 60), random(80, height - 60)); }

void display() {
// stem
stroke(40, 120, 40);
strokeWeight(2);
line(position.x, position.y + 4, position.x + 10, position.y + 18);
// four leaf clover
noStroke();
fill(70, 170, 80);
ellipse(position.x - 6, position.y - 6, 12, 12);
ellipse(position.x + 6, position.y - 6, 12, 12);
ellipse(position.x - 6, position.y + 6, 12, 12);
ellipse(position.x + 6, position.y + 6, 12, 12);
// middle point
fill(40, 120, 50);
circle(position.x, position.y, 5);}
}

//Bird Class
class Bird {
PVector position;
PVector velocity;
PVector acceleration;
Bird(float x, float y) {
position = new PVector(x, y);
velocity = new PVector(1, 1);
acceleration = new PVector(0, 0); }

//Tracking worms
void applyForce(PVector force) {
acceleration.add(force); }

void update(PVector target) {

//calculate the direction from the bird to the worm
PVector direction = PVector.sub(target, position);
//Reduce the force, otherwise the bird will fly too fast
direction.normalize();
direction.mult(0.07);
applyForce(direction);

velocity.add(acceleration);
velocity.limit(2.4);
position.add(velocity);

//Limit the bird's maximum speed so that the game is not too difficult
acceleration.mult(0); }

//The bird is drawn in its position and rotates towards the direction of flight
void display() {
pushMatrix();
translate(position.x, position.y);
rotate(velocity.heading());

// shadow
noStroke();
fill(0, 60);
ellipse(0, 10, 80, 25);

// tail
fill(20);
triangle(-30, 0, -52, -12, -52, 12);

// wings
fill(15);
triangle(-5, 0, -28, -35, 10, -8);
triangle(-5, 0, -28, 35, 10, 8);

// body
fill(25);
ellipse(0, 0, 45, 28);

// sharp beak
// point of the beak is at the front
fill(90);
triangle(50, 0, 22, -8, 22, 8);

// red eye
fill(255, 0, 0);
circle(12, -5, 5);

popMatrix();}
}
