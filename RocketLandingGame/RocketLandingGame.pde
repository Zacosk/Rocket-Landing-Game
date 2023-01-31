float gravity, deltaTime, oldMillis;
int terrainMaxHeight, terrainMinHeight;
PShape terrain;
LandingPad landingPad;

Rocket rocket;

void setup()
{
  size(800, 500);
  smooth(8);
  
  terrainMaxHeight = 250;
  terrainMinHeight = 500;
  
  gravity = 0.15;
  rocket = new Rocket();
  landingPad = new LandingPad(new PVector(width/2, 400));
  GenerateTerrain();
  noStroke();
}

void draw()
{
  background(59, 97, 99);
  DrawTerrain();
  rocket.Draw();
  rocket.Move();
  rocket.DrawFuel();
  rocket.CheckCollision();
  CheckRocketOffscreen();
}

void GenerateTerrain()
{
  
  noiseSeed((int)random(0, 99));
  int landingPadStart = (int)random(1, 20);
  
  terrain = createShape();
  terrain.beginShape();
  terrain.noStroke();
  terrain.fill(16, 36, 25);
  terrain.vertex(0, 500);
  
  PVector lastTerrainPos = new PVector(0, 0);
  
  for(int i = 0; i < 20; i++)
  {
    if (i == landingPadStart)
    {
      landingPad = new LandingPad(new PVector(i*40, (map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight))));
      terrain.vertex(i*40, map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight));
      terrain.vertex(i*40, map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight) + 20);
      
      terrain.vertex((i+1)*40, map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight) + 20);
      terrain.vertex((i+1)*40, map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight));
      break;
    }
    terrain.vertex(i*40, map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight));
  }
  terrain.vertex(800, 500);
  terrain.endShape(CLOSE);
}

void DrawTerrain()
{
  shape(terrain, 0, 0);
  landingPad.Draw();
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

void CheckRocketOffscreen()
{
  if (rocket.shipPos.x < 0 || rocket.shipPos.x > 800 || rocket.shipPos.y < 0)
  {
    PVector indicatorPos = new PVector(rocket.shipPos.x, rocket.shipPos.y);
    PVector textPos = new PVector(indicatorPos.x, indicatorPos.y+5);
    if (rocket.shipPos.x < 0)
    {
      textAlign(LEFT);
      indicatorPos.x = 10;
      textPos.x = 20;
    } else if (rocket.shipPos.x > 800)
    {
      textAlign(RIGHT);
      textPos.x = 780;
      indicatorPos.x = 790;
    }
    if (rocket.shipPos.y < 0)
    {
      textAlign(CENTER);
      textPos.y = 35;
      indicatorPos.y = 10;
    }
    
    fill(255, 0, 0);
    textSize(20);
    circle(indicatorPos.x, indicatorPos.y, 10);
    text(String.valueOf((int)Math.sqrt(Math.pow(indicatorPos.x - rocket.shipPos.x, 2) + Math.pow(indicatorPos.y - rocket.shipPos.y, 2))), textPos.x, textPos.y);
  }
}

void ResetGame()
{
  rocket.ResetShip();
  rocket.fuel = 100;
  rocket.startFreeze = true;
  GenerateTerrain();
}
