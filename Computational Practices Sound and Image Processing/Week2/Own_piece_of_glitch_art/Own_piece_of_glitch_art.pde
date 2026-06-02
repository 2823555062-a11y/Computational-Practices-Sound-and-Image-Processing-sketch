PImage sample;

void setup() {
  size(1000, 1000);

  sample = loadImage("picture2.jpg");
  sample.resize(550, 0);

  // 1. Swap colour channels first
  swapColourChannels();

  // 2. Increase brightness
  increaseBrightness();

  // 3. Create melting drip effect using vertical pixel sorting
  verticalPixelSort();

  noLoop();
}

void draw() {
  background(255);

  // Place picture in the horizontal centre
  int imageX = (width - sample.width) / 2;
  image(sample, imageX, 0);

  fill(0);
  textSize(18);
  text("Colour Swapped + Brightened + Pixel Sorting Melt", imageX, sample.height + 40);
}

void swapColourChannels() {
  sample.loadPixels();

  for (int i = 0; i < sample.pixels.length; i++) {
    color c = sample.pixels[i];

    int r = int(red(c));
    int g = int(green(c));
    int b = int(blue(c));

    // Swap red and blue channels: RGB becomes BGR
    sample.pixels[i] = color(b, g, r);
  }

  sample.updatePixels();
}

void increaseBrightness() {
  sample.loadPixels();

  for (int i = 0; i < sample.pixels.length; i++) {
    color c = sample.pixels[i];

    float r = red(c);
    float g = green(c);
    float b = blue(c);

    // Increase brightness
    r = constrain(r * 1.25 + 20, 0, 255);
    g = constrain(g * 1.25 + 20, 0, 255);
    b = constrain(b * 1.25 + 20, 0, 255);

    sample.pixels[i] = color(r, g, b);
  }

  sample.updatePixels();
}

void verticalPixelSort() {
  sample.loadPixels();

  float threshold = 140;

  // Go through each column
  for (int x = 0; x < sample.width; x++) {
    int y = 0;

    while (y < sample.height) {

      // Find the start of a bright section
      while (y < sample.height && brightness(sample.pixels[y * sample.width + x]) < threshold) {
        y++;
      }

      int startY = y;

      // Find the end of the bright section
      while (y < sample.height && brightness(sample.pixels[y * sample.width + x]) >= threshold) {
        y++;
      }

      int endY = y;

      // Only sort longer sections
      if (endY - startY > 8) {
        sortColumnSection(x, startY, endY);
      }
    }
  }

  sample.updatePixels();
}

void sortColumnSection(int x, int startY, int endY) {
  int length = endY - startY;
  color[] section = new color[length];

  // Copy pixels from the column section
  for (int i = 0; i < length; i++) {
    int index = (startY + i) * sample.width + x;
    section[i] = sample.pixels[index];
  }

  // Sort by brightness
  for (int i = 0; i < length - 1; i++) {
    for (int j = 0; j < length - i - 1; j++) {
      if (brightness(section[j]) > brightness(section[j + 1])) {
        color temp = section[j];
        section[j] = section[j + 1];
        section[j + 1] = temp;
      }
    }
  }

  // Put sorted pixels back
  for (int i = 0; i < length; i++) {
    int index = (startY + i) * sample.width + x;
    sample.pixels[index] = section[i];
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("pixel_sort_melting_result.png");
  }
}
