import processing.svg.*;

int xspacing = 8;
int w;
int maxwaves = 4;
int numStrings = 5;

float theta = 0.0;
float[] amplitude = new float[maxwaves];
float[][] amplitudes = new float[numStrings][maxwaves];
float[] dx = new float[maxwaves];
float[][] dxs = new float[numStrings][maxwaves];
float[] yvalues;
float[][] strings;

// page size
// A4 210x297 => 0.707
int A4Width = 1024;
int A4Height = 768; //int(A4Width * 0.71);

void setup() {
  // a4/letter ratio
  //size(A4Width, A4Height);
  size(1024, 768);
  frameRate(30);
  colorMode(RGB, 255, 255, 255, 100);
  w = width + 16;
  
  for (int n = 0; n < numStrings; n++) {
    for (int i = 0; i < maxwaves; i++) {
      amplitudes[n][i] = random(10, 30);
      float period = random(100, 300);
      dxs[n][i] = (TWO_PI / period) * xspacing;
    }
  }

  yvalues = new float[w / xspacing];
  strings = new float[numStrings][w / xspacing];
  
  noLoop();
  noFill();
  beginRecord(SVG, fileName("strings", "svg"));
}

void draw() {
  background(255);
  //renderCircle();
  calcWave();
  renderWave();
  
  endRecord();
}

void renderCircle() {
   ellipseMode(CENTER);
   ellipse(100, 100, 100, 100);
}

void calcWave() {
  theta += 2;
  
  for (int n = 0; n < numStrings; n++) {
    for (int i = 0; i < yvalues.length; i++) {
      yvalues[i] = 0;
      strings[n][i] = 0;
    }
  }
  
  for (int n = 0; n < numStrings; n++) {    
    for (int j = 0; j < maxwaves; j++) {
      float x = theta;
      
      for (int i = 0; i < yvalues.length; i++) {
        if (j % 2 == 0) {
          strings[n][i] = yvalues[i] += sin(x) * amplitudes[n][j];
        } else {
          strings[n][i] = yvalues[i] += cos(x) * amplitudes[n][j];
        }
        
        x += dxs[n][j];
      }
    }
  }
}

void renderWave() {
  ellipseMode(CENTER);
  
  int ySteps = (height - 2 * 30) / numStrings;
  
  for(int n = 0; n < numStrings; n++) {
    int yPos = 30 + ySteps / (2 + n) + n * ySteps;
    
    for (int x = 0; x < yvalues.length; x++) {
      stroke(3);
      float yvaluex = strings[n][x];
      ellipse(x * xspacing, yPos + yvaluex, 10 + yvaluex, 10 + yvaluex);
    }
  }
}

static final String fileName(final String name, final String ext) {
  return name + "-" + year() + nf(month(), 2) + nf(day(), 2) +
    "-" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + "." + ext;
}
