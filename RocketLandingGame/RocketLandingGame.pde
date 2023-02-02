float gravity, deltaTime, oldMillis;
int terrainMaxHeight, terrainMinHeight;
PShape terrain;
PVector indicatorPos, textIndicatorPos;
color backgroundCol, terrainCol, rocketCol;

LandingPad landingPad;
Rocket rocket;

void setup()
{
  size(800, 500);
  smooth(8);
  
  terrainMaxHeight = 250;
  terrainMinHeight = 500;
  
  GenerateColours();
  rocket = new Rocket(rocketCol);
  landingPad = new LandingPad(new PVector(width/2, 400));
  GenerateTerrain();
  noStroke();
}

void draw()
{
  background(backgroundCol);
  DrawTerrain();
  rocket.Draw();
  rocket.Move();
  rocket.DrawFuel();
  rocket.CheckCollision();
  CheckRocketOffscreen();
}

void GenerateColours()
{
  int num = (int)random(0, 5);
  switch (num)
  {
    case 0: backgroundCol = color(75,134,180); rocketCol = color(173,203,227); terrainCol = color(42,77,105); break;
    case 1: backgroundCol = color(224,172,105); rocketCol = color(198,134,66); terrainCol = color(141,85,36); break;
    case 2: backgroundCol = color(208,18,18); rocketCol = color(151,2,3); terrainCol = color(81,6,6); break;
    case 3: backgroundCol = color(163,146,229); rocketCol = color(103,78,167); terrainCol = color(53,28,117); break;
    case 4: backgroundCol = color(138,234,0); rocketCol = color(0,186,24); terrainCol = color(0,59,8); break;
    //case 4: backgroundCol = color(); rocketCol = color(); terrainCol = color(); break;
  }
}

void GenerateTerrain()
{
  noiseSeed((int)random(0, 99));
  int landingPadStart = (int)random(1, 20);
  
  terrain = createShape();
  terrain.beginShape();
  terrain.noStroke();
  terrain.fill(terrainCol);
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

void CheckRocketOffscreen()
{
  if (rocket.shipPos.x < 0 || rocket.shipPos.x > 800 || rocket.shipPos.y < 0)
  {
    indicatorPos = new PVector(rocket.shipPos.x, rocket.shipPos.y);
    textIndicatorPos = new PVector(indicatorPos.x, indicatorPos.y+5);
    if (rocket.shipPos.x < 0)
    {
      textAlign(LEFT);
      indicatorPos.x = 10;
      textIndicatorPos.x = 20;
    } else if (rocket.shipPos.x > 800)
    {
      textAlign(RIGHT);
      textIndicatorPos.x = 780;
      indicatorPos.x = 790;
    }
    if (rocket.shipPos.y < 0)
    {
      textAlign(CENTER);
      textIndicatorPos.y = 35;
      indicatorPos.y = 10;
    }
    
    fill(255);
    textSize(20);
    circle(indicatorPos.x, indicatorPos.y, 10);
    text(String.valueOf((int)Math.sqrt(Math.pow(indicatorPos.x - rocket.shipPos.x, 2) + Math.pow(indicatorPos.y - rocket.shipPos.y, 2))), textIndicatorPos.x, textIndicatorPos.y);
  }
}

void ResetGame()
{
  GenerateColours();
  rocket.GenerateRocketShape(rocketCol);
  rocket.ResetShip();
  rocket.fuel = 100;
  rocket.startFreeze = true;
  
  GenerateTerrain();
}
