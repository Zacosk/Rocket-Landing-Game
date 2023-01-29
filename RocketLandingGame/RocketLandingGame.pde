float fuel, acceleration, upAcceleration, sideAcceleration, gravity, rotation, rotationSpeed;
boolean throttleUp, turnLeft, turnRight, startFreeze;
PVector shipPos;
TerrainPoint[] terrainPoints = new TerrainPoint[800];

void setup()
{
  size(800, 500);
  shipPos = new PVector(width/2, height/2);
  gravity = 3;
  rotationSpeed = 1.5;
  fuel = 100;
  GenerateTerrain();
  noStroke();
  startFreeze = true;
}

void draw()
{
  background(59, 97, 99);
  DrawTerrain();
  DrawShip();
  MoveShip();
  DrawFuel();
  CheckCollision();
}

void DrawShip()
{
  pushMatrix();
  translate(shipPos.x, shipPos.y);
  rotate(radians(rotation));
  rectMode(CENTER);
  fill(255);
  rect(0, 0, 20, 30);
  if (throttleUp && fuel > 0)
  {
    fill(255, 0, 0);
    triangle(8, 15, -8, 15, 0, 30);
    fill(255, 165, 0);
    triangle(6, 15, -6, 15, 0, 20);
  }
  popMatrix();
}

void MoveShip()
{
  if (startFreeze)
  {
    return;
  }
  if (throttleUp && fuel >= 0)
  {
   acceleration += 0.1;
   fuel -= 0.1;
  } else {
    acceleration -= 0.2; 
  }
  
  acceleration = constrain(acceleration, 0, 5);
  
  upAcceleration = acceleration * GetVelocityComponent(rotation, true);
  sideAcceleration += (acceleration * 0.2) * GetVelocityComponent(rotation, false);
  
  sideAcceleration = constrain(sideAcceleration, -3, 3);
  
  shipPos.y += gravity - (upAcceleration);
  shipPos.x += sideAcceleration;

  if (turnLeft) 
  {
    rotation +=rotationSpeed * -1;
  }
  
  if (turnRight)
  {
    rotation += rotationSpeed * 1;
  }
  
  //lock rotation between 0-360
  if (rotation > 360) {
    rotation = 0;
  } else if (rotation < 0) {
    rotation = 360;
  }
}

void DrawFuel()
{
  println(frameRate);
  fill(255);
  rectMode(CORNER);
  rect(200, 50, map(fuel, 0, 100, 0, 400), 20);
}

void GenerateTerrain()
{
  int landingPadStart = (int)random(1, 750);
  float inc = TWO_PI/300;
  float a = 0;
  
  for(int i = 0; i < terrainPoints.length; i++)
  {
    int yPos = 450 + (int)(sin(a)*50);
    boolean bol = false;
    if (i >= landingPadStart && i <= landingPadStart + 40)
    {
      bol = true;
    }
    terrainPoints[i] = new TerrainPoint(new PVector(i, yPos), bol);
    a+=inc;//200000;
  }
}

void DrawTerrain()
{
  for(int i = 0; i < terrainPoints.length; i++)
  {
    terrainPoints[i].Draw();
  }
}

void CheckCollision()
{
  for (int i = (int)shipPos.x - 10; i < (int)shipPos.x + 10; i++)
  {
    i = constrain(i, 1, width);
    if (terrainPoints[i].CheckCrash((int)shipPos.y) == 1)
    {
      ResetShip();
    } else if (terrainPoints[i].CheckCrash((int)shipPos.y) == 2){
      FreezeShip();
    }
  }
}

float GetVelocityComponent(float rotation, boolean up)
{
  if (up) 
  {
    if (rotation <= 90 || rotation >= 270)
    {
      if (rotation <= 90)
      {
        return map(rotation, 0, 90, 1, 0);
      } else if (rotation >= 270)
      {
        return map(rotation, 270, 360, 0, 1);
      }
    } else {
      if (rotation >= 90 && rotation <= 180)
      {
        return map(rotation, 90, 180, 0, -1);
      } else if (rotation >= 180 && rotation <= 270)
      {
        return map(rotation, 180, 270, -1, 0);
      }
    }
    //side movement calculation
  } else {
    if (rotation >= 0 && rotation <= 180)
    {
      if (rotation >= 0 && rotation <= 90)
      {
        return map(rotation, 0, 90, 0, 1);
      } else if (rotation >= 90 && rotation <= 180)
      {
        return map(rotation, 90, 180, 1, 0);
      }
    } else {
      if (rotation >= 180 && rotation <= 270)
      {
        return map(rotation, 180, 270, 0, -1);
      } else if (rotation >= 270 && rotation <= 360)
      {
        return map(rotation, 270, 360, -1, 0);
      }
    }
  }
  return 1;
}

void FreezeShip()
{
  fuel = 0;
  gravity = 0;
  acceleration = 0;
  upAcceleration = 0;
  sideAcceleration = 0;
  rotation = 0;
}

void ResetShip()
{
  shipPos.x = width/2;
  shipPos.y = height/2;
  acceleration = 0;
  upAcceleration = 0;
  sideAcceleration = 0;
  gravity = 3;
}

void keyPressed() {
  if (key == ' ') {
    println("Ship Accl: " + acceleration + ",rot: " + rotation + ",Up Accl: " + upAcceleration + ", side Accl: " + sideAcceleration);
    println("accl:" + acceleration + " * v comp:" + GetVelocityComponent(rotation, false) + " = " + sideAcceleration);  
}
  if (key == 'r')
  {
    ResetShip();
  }
  if (key == CODED) {
    if (keyCode == UP) {
      throttleUp = true;
    }
    if (keyCode == LEFT) {
      turnLeft = true;
    } else if (keyCode == RIGHT) {
      turnRight = true;
    }
  }
  if (startFreeze)
  {
    startFreeze = false;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      throttleUp = false;
    }
    if (keyCode == LEFT) {
      turnLeft = false;
    } else if (keyCode == RIGHT) {
      turnRight = false;
    }
  }
}
