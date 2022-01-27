import java.awt.Robot;

boolean upkey, downkey, leftkey, rightkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftRightHeadAngle, upDownHeadAngle;

color black = #000000;   // diamond
color white = #FFFFFF;   // empty space
color dullBlue = #7092BE;  // nether

int gridSize;
PImage map;

PImage nether;
PImage diamond;
PImage elexir;

Robot rbt;
boolean skipFrame;

void setup () {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  upkey = downkey = leftkey =  rightkey = false;
  eyeX = width/2;
  eyeY = height - 100;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;
  leftRightHeadAngle = radians(270);
  noCursor();

  map = loadImage("map.png");
  gridSize = 100;

  nether = loadImage("NetherPortal.jpg");
  diamond = loadImage("diamond.png");
  elexir = loadImage("elexir.png");

  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  skipFrame = false;
}

void draw () {
  background(0);

  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);

  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);

  drawFloor(-2000, 2000, height, gridSize);
  drawFloor(-2000, 2000, height - gridSize * 4, gridSize);
  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawMap () {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == dullBlue) {
        texturedCube(x * gridSize - 2000, height - gridSize, y * gridSize - 2000, elexir, gridSize);
        texturedCube(x * gridSize - 2000, height - gridSize * 2, y * gridSize - 2000, elexir, gridSize);
        texturedCube(x * gridSize - 2000, height - gridSize * 3, y * gridSize - 2000, elexir, gridSize);
      }
      if (c == black) {
        texturedCube(x * gridSize - 2000, height - gridSize, y * gridSize - 2000, elexir, gridSize);
        texturedCube(x * gridSize - 2000, height - gridSize * 2, y * gridSize - 2000, elexir, gridSize);
        texturedCube(x * gridSize - 2000, height - gridSize * 3, y * gridSize - 2000, elexir, gridSize);
      }
    }
  }
}

void drawFocalPoint () {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(1);
  popMatrix();
}

void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, nether, gap);
    x = x + gap;
    if (x >= end) {
      x = start;
      z = z + gap;
    }
  }
}

void controlCamera() {
  if (upkey) {
    eyeZ = eyeZ + sin(leftRightHeadAngle) * 10;
    eyeX = eyeX + cos(leftRightHeadAngle) * 10;
  }
  if (downkey) {
    eyeZ = eyeZ - sin(leftRightHeadAngle) * 10;
    eyeX = eyeX - cos(leftRightHeadAngle) * 10;
  }
  if (leftkey) {
    eyeZ = eyeZ - sin(leftRightHeadAngle + PI/2) * 10;
    eyeX = eyeX - cos(leftRightHeadAngle + PI/2) * 10;
  }
  if (rightkey) {
    eyeZ = eyeZ - sin(leftRightHeadAngle - PI/2) * 10;
    eyeX = eyeX - cos(leftRightHeadAngle - PI/2) * 10;
  }

  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX) * 0.01;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY) * 0.01;
  }
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle) * 300;
  focusZ = eyeZ + sin(leftRightHeadAngle) * 300;
  focusY = eyeY + tan(upDownHeadAngle) * 300;

  if (mouseX > width-2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) {
    skipFrame = true;
    rbt.mouseMove(width-3, mouseY);
  } else {
  skipFrame = false;
  }
}

void keyPressed () {
  if (key == 'w') upkey = true;
  if (key == 's') downkey = true;
  if (key == 'a') leftkey = true;
  if (key == 'd') rightkey = true;

  if (key == 'W') upkey = true;
  if (key == 'S') downkey = true;
  if (key == 'A') leftkey = true;
  if (key == 'D') rightkey = true;
}

void keyReleased () {
  if (key == 'w') upkey = false;
  if (key == 's') downkey = false;
  if (key == 'a') leftkey = false;
  if (key == 'd') rightkey = false;

  if (key == 'W') upkey = false;
  if (key == 'S') downkey = false;
  if (key == 'A') leftkey = false;
  if (key == 'D') rightkey = false;
}
