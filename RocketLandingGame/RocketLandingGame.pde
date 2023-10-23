float gravity, deltaTime, oldMillis;
int terrainMaxHeight, terrainMinHeight, terrainPointNum, segColNum;
PShape terrain, indicator;
PVector indicatorPos, textIndicatorPos;
color backgroundCol, terrainCol, rocketCol;
ArrayList<CollisionPoint> collisionPoints = new ArrayList<CollisionPoint>();
GameStates gameState;
ArrayList<Button> controlButtons = new ArrayList<Button>();

LandingPad landingPad;
Rocket rocket;

enum GameStates {
  Start,
  Playing,
  Lost,
  Won
}

enum ControlModes {
  Default, Burst
}

void setup()
{
  size(800, 600);
  smooth(8);
  pixelDensity(displayDensity());
  frameRate(120);
  surface.setIcon(loadImage("Icon.png"));
  surface.setTitle("Rocket Lander");
  
  terrainMaxHeight = height-250;
  terrainMinHeight = height;
  terrainPointNum = 20;
  segColNum = terrainPointNum/10;
  
  rocket = new Rocket(rocketCol);
  ResetGame();
  GenerateIndicator();
  noStroke();
  
  gameState = GameStates.Start;
  
  //Generate buttons
  controlButtons.add(new Button("Default", new PVector(56, 335), new PVector(75, 25)));
  controlButtons.add(new Button("Burst", new PVector(140, 335), new PVector(75, 25)));
  controlButtons.get(0).selected = true;
  rocket.SetControlMode(ControlModes.Default);
}

void draw()
{
  background(backgroundCol);
  DrawTerrain();
  rocket.Draw();
  
  switch(gameState) {
    case Start: 
      DrawStart(); 
    break;
    case Playing: 
      rocket.DrawFuel();
      rocket.Move();
      rocket.CheckCollision();
      CheckRocketOffscreen();
    break;
    default:
      DrawEndGame();
    break;
  }
  //println(frameRate);
}

void GenerateColours()
{
  int num = (int)random(0, 6);
  switch (num)
  {
    /*blue*/case 0: backgroundCol = color(75,134,180); rocketCol = color(173,203,227); terrainCol = color(42,77,105); break;
    /*brown*/case 1: backgroundCol = color(224,172,105); rocketCol = color(198,134,66); terrainCol = color(141,85,36); break;
    /*red*/case 2: backgroundCol = color(203,40,40); rocketCol = color(151,2,3); terrainCol = color(81,6,6); break;
    /*purple*/case 3: backgroundCol = color(163,146,229); rocketCol = color(103,78,167); terrainCol = color(53,28,117); break;
    /*green*/case 4: backgroundCol = color(138,234,0); rocketCol = color(0,186,24); terrainCol = color(0,59,8); break;
    /*yellow*/case 5: backgroundCol = color(254, 222, 58); rocketCol = color(255, 254, 230); terrainCol = color(244, 187, 0); break;
    //case 4: backgroundCol = color(); rocketCol = color(); terrainCol = color(); break;
  }
}

void GenerateTerrain()
{
  noiseSeed((int)random(0, 255));
  int landingPadStart = (int)random(1, terrainPointNum);
  int terrainPointSpacing = width/terrainPointNum;
  
  terrain = createShape();
  terrain.beginShape();
  terrain.noStroke();
  terrain.fill(terrainCol);
  terrain.vertex(0, height);
  
  //PVector lastTerrainPos = new PVector(0, 0);
  
  for(int i = 0; i < terrainPointNum; i++)
  {
    if (i == landingPadStart)
    {
      landingPad = new LandingPad(new PVector(i*terrainPointSpacing, (map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight))));
      float terrainHeight = map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight);
      terrain.vertex(i*terrainPointSpacing, terrainHeight);
      
      terrain.vertex((i+1)*terrainPointSpacing, terrainHeight);
      i++;
    } else {
      terrain.vertex(i*terrainPointSpacing, map(noise(i), 0, 1, terrainMaxHeight, terrainMinHeight));  
    }
  }
  terrain.vertex(width, height);
  terrain.endShape(CLOSE);
}

void GenerateCollisionPoints()
{
  //iterate over terrain vertex points and generate collision points
  for (int i = 0; i < terrain.getVertexCount(); i++)
  {
    collisionPoints.add(new CollisionPoint(terrain.getVertex(i)));
    //iterate over sections between collision points and generate collision points
    int segmentCollisionNum = segColNum;
    try {
      //if y difference is too great, add another collision point
      float distance = Math.abs(dist(terrain.getVertex(i).x, terrain.getVertex(i).y, terrain.getVertex(i+1).x, terrain.getVertex(i+1).y));
      if (distance > 50)
        {
          segmentCollisionNum += 1;
        } if (distance > 80) {
          segmentCollisionNum += 2; 
        }
          
        float spacing = 1.0/(segmentCollisionNum+1);
      for (int j = 1; j <= segmentCollisionNum; j++)
      {
        collisionPoints.add(new CollisionPoint(new PVector(lerp(terrain.getVertex(i).x, terrain.getVertex(i+1).x, spacing*j), lerp(terrain.getVertex(i).y, terrain.getVertex(i+1).y, spacing*j))));
      }  
    }
    catch(Exception e)
    {}
  }
}

void GenerateIndicator()
{
    indicator = createShape();
    indicator.beginShape();
    indicator.noStroke();
    indicator.fill(255);
    indicator.vertex(0, 0);
    indicator.vertex(5, 12);
    indicator.vertex(0, 9);
    indicator.vertex(-5, 12);
    indicator.endShape(CLOSE);
}

boolean CheckTerrainCollision()
{
  for (int i = 0; i < collisionPoints.size(); i++)
  {
    //collisionPoints.get(i).DrawDebug();
    if (collisionPoints.get(i).CheckCollision(rocket.shipPos))
    {
      return true;
    }
  }
  return false;
}

void DrawTerrain()
{
  landingPad.Draw();
  shape(terrain, 0, 0);
}

void CheckRocketOffscreen()
{
  if (rocket.shipPos.x < 0 || rocket.shipPos.x > width || rocket.shipPos.y < 0)
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
      textIndicatorPos.x = width-20;
      indicatorPos.x = width-10;
    }
    if (rocket.shipPos.y < 0)
    {
      textAlign(CENTER);
      textIndicatorPos.y = 35;
      indicatorPos.y = 10;
    }
    
    fill(255);
    textSize(20);
    //circle(indicatorPos.x, indicatorPos.y, 10);
    
    push();
    shapeMode(CENTER);
    translate(indicatorPos.x, indicatorPos.y);
    rotate(radians(rocket.rotation));
    shape(indicator, 0, 0);
    pop();

    text(String.valueOf((int)Math.sqrt(Math.pow(indicatorPos.x - rocket.shipPos.x, 2) + Math.pow(indicatorPos.y - rocket.shipPos.y, 2))), textIndicatorPos.x, textIndicatorPos.y);
  }
}

void DrawStart() 
{
  fill(rocketCol);
  textSize(60);
  text("Rocket Lander", 10, 55);
  textSize(30);
  text("Press Up Arrow to start", 13, 90);
  
  textAlign(CENTER);
  stroke(rocketCol);
  noFill();
  strokeWeight(2);
  rect(8, 160, 180, 200, 10);
  textSize(30);
  text("Controls:", 98, 186);
  textSize(20);
  text("Up arrow - Throttle", 98, 215);
  text("Side arrows - Rotate", 98, 240);
  text("R - Reset", 98, 265);
  
  textSize(30);
  text("Mode:", 98, 305);
  textAlign(LEFT);
  noStroke();
  
  for (Button button : controlButtons)
  {
    button.Run();
  }
}

void DrawEndGame()
{
  String displayText = "Game Over";
  if (gameState == GameStates.Won)
  {
    displayText = "Game Won";
  }
  fill(rocketCol);
  textAlign(CENTER);
  textSize(60);
  text(displayText, width/2, 60);
  textSize(25);
  text("Press 'r' for new level", width/2, 90);
  textAlign(LEFT);
}

void ResetGame()
{
  GenerateColours();
  rocket.GenerateRocketShape(rocketCol);
  rocket.ResetShip();
  rocket.fuel = rocket.startingFuel;
  collisionPoints.clear();
  
  GenerateTerrain();
  GenerateCollisionPoints();
  
  gameState = GameStates.Start;
}

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    for (int i = 0; i < controlButtons.size(); i++)
    {
      if (controlButtons.get(i).hover)
      {
        ButtonControls(i, true);
      }
    }
  }
}

void ButtonControls(int btnNum, boolean controls)
{
  if (controls)
  {
    switch(btnNum)
    {
      case 0: rocket.SetControlMode(ControlModes.Default);
      break;
      case 1: rocket.SetControlMode(ControlModes.Burst);
      break;
    }
    for (int i = 0; i < controlButtons.size(); i++)
    {
      controlButtons.get(i).selected = false;
    }
    controlButtons.get(btnNum).selected = true;
  }
}
