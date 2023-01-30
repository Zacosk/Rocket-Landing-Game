float gravity, deltaTime, oldMillis;
PShape terrain;
LandingPad landingPad;

Rocket rocket;

void setup()
{
  size(800, 500);
  smooth(8);
  
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
  //rocket.CheckCollision();
}

void GenerateTerrain()
{
  int landingPadStart = (int)random(1, 20);
  
  terrain = createShape();
  terrain.beginShape();
  terrain.noStroke();
  terrain.fill(16, 36, 25);
  terrain.vertex(0, 500);
  
  for(int i = 0; i <= 20; i++)
  {
    if (i == landingPadStart + 1)
    {
      landingPad = new LandingPad(new PVector(i*40, (map(noise(i-1), 0, 1, 350, 550))));
      terrain.vertex(i*40, map(noise(i-1), 0, 1, 350, 550));
      break;
    }
    terrain.vertex(i*40, map(noise(i), 0, 1, 350, 550));
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
