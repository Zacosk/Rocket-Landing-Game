float gravity, deltaTime, oldMillis;
PShape terrain;

Rocket rocket;
TerrainPoint[] terrainPoints = new TerrainPoint[800];

void setup()
{
  size(800, 500);
  smooth(8);
  
  gravity = 0.15;
  rocket = new Rocket();
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
}

void GenerateTerrain()
{
  terrain = createShape();
  terrain.beginShape();
  terrain.noStroke();
  //terrain.fill(16, 36, 25);
  terrain.fill(255, 0, 0);
  terrain.vertex(0, 500);
  for(int i = 0; i <= 80; i++)
  {
    terrain.vertex(i*10, map(noise(i), 0, 1, 400, 500));
  }
  terrain.vertex(800, 500);
  terrain.endShape(CLOSE);
  /*
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
    //terrainPoints[i] = new TerrainPoint(new PVector(i, yPos), bol);
    terrainPoints[i] = new TerrainPoint(new PVector(i, 100*(noise(i))), bol);
    a+=inc;//200000;
  }*/
}

void DrawTerrain()
{
  shape(terrain, 0, 0);
  /*
  for(int i = 0; i < terrainPoints.length; i++)
  {
    terrainPoints[i].Draw();
  } */
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
