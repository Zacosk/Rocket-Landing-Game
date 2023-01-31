public class Rocket
{
  float fuel, acceleration, upAcceleration, sideAcceleration, rotation, rotationSpeed;
  PVector shipPos;
  boolean throttleUp, turnLeft, turnRight, startFreeze;
  ArrayList<Smoke> smokeTrail = new ArrayList<Smoke>();
  PShape rocket, flame;
  
  public Rocket()
  {
    shipPos = new PVector(width/2, height/2);
    rotationSpeed = 0.1;
    fuel = 100;
    startFreeze = true;
    
    flame = createShape(GROUP);
    
    GenerateRocketShape();
    GenerateFlameShapes();
  }
  
  void GenerateRocketShape()
  {
    rocket = createShape();
    rocket.beginShape();
    rocket.noStroke();
    rocket.fill(0, 191, 44);
    rocket.vertex(0, 0);
    rocket.vertex(10, 50);
    rocket.vertex(-10, 50);
    rocket.endShape(CLOSE);
  }
  
  void GenerateFlameShapes()
  {
    PShape outerFlame = createShape(TRIANGLE, 8, 15, -8, 15, 0, 30);
    outerFlame.setFill(color(255, 0, 0));
    outerFlame.setStroke(false);
    PShape innerFlame = createShape(TRIANGLE, 6, 15, -6, 15, 0, 20);
    innerFlame.setFill(color(255, 165, 0));
    innerFlame.setStroke(false);
    flame.addChild(outerFlame);
    flame.addChild(innerFlame);
  }
  
  void Draw()
  {
    //Smoke
    ArrayList<Integer> deadSmoke = new ArrayList<Integer>();
    for (int i = 0; i < smokeTrail.size(); i++)
    {
      smokeTrail.get(i).Draw();
      smokeTrail.get(i).Decay();
      if (smokeTrail.get(i).life < 0)
      {
        deadSmoke.add(i);
      }
    }
    
    for (int i = 0; i < deadSmoke.size(); i++)
    {
      smokeTrail.remove(i);
    }
    
    //Rocket
    pushMatrix();
    translate(shipPos.x, shipPos.y);
    rotate(radians(rotation));
    shape(rocket, 0, -45);
  
    if (throttleUp && fuel > 0)
    {
      scale(1, random(0, 2));
      shape(flame, 0, -10);
      scale(1);
    }
    popMatrix();
  }
  
  void DrawFuel()
  {
    fill(255);
    rectMode(CORNER);
    rect(200, 50, map(fuel, 0, 100, 0, 400), 20);
  }
  
  void Move()
  {
    CalculateDeltaTime();
    if (startFreeze)
    {
      return;
    }
  
    if (throttleUp && fuel >= 0)
    {
      smokeTrail.add(new Smoke(255, new PVector(shipPos.x, shipPos.y+20)));
      acceleration += 0.1;
      fuel -= 0.1;
    } else {
    acceleration -= 0.2; 
    }
  
    acceleration = constrain(acceleration, 0, 0.3);
  
    upAcceleration = acceleration * GetVelocityComponent(rotation, true);
    sideAcceleration += (acceleration * 0.2) * GetVelocityComponent(rotation, false);
  
    sideAcceleration = constrain(sideAcceleration, -0.3, 0.3);
    
    //main movement calculation
    shipPos.y += (gravity - (upAcceleration)) * deltaTime;
    shipPos.x += sideAcceleration * deltaTime;

    if (turnLeft) 
    {
      rotation += rotationSpeed * -1 * deltaTime;
    }
  
    if (turnRight)
    {
      rotation += rotationSpeed * 1 * deltaTime;
    }
  
    //lock rotation between 0-360
    if (rotation > 360) {
      rotation = 0;
    } else if (rotation < 0) {
      rotation = 360;
    }
  }
  
  void CheckCollision()
  {
    /*for (int y = 50; y > 0 ; y--)
    {
      int xLength = 10;
      for (int x = (-1 * xLength); y >= xLength; y++)
      { 
        if (terrain.contains(shipPos.x + x, shipPos.y + y))
        {
          ResetShip();
        }
      }
      xLength -= 2;
    }*/
    
    if (terrain.contains(shipPos.x, shipPos.y))
    {
      ResetShip();
    } else if (landingPad.landingPad.contains(shipPos.x, shipPos.y))
    {
      FreezeShip();
    }
  }
  
  void ResetShip()
  {
    shipPos.x = width/2;
    shipPos.y = height/2;
    acceleration = 0;
    rotation = 0;
    upAcceleration = 0;
    sideAcceleration = 0;
    gravity = 0.15;
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
  
  void CalculateDeltaTime()
  {
    deltaTime = millis() - oldMillis;
    oldMillis = millis();
    //println("fps: " + frameRate + ", delta: " + deltaTime);
  }
  
  void PrintDebug()
  {
    println("Ship Accl: " + acceleration + ",rot: " + rotation + ",Up Accl: " + upAcceleration + ", side Accl: " + sideAcceleration);
    println("accl:" + acceleration + " * v comp:" + GetVelocityComponent(rotation, false) + " = " + sideAcceleration);  
  }
}
  
void keyPressed() 
{
  if (key == ' ') 
  {
    rocket.PrintDebug();
  }

  if (key == 'r')
  {
    ResetGame();
  }
  if (key == CODED) 
  {
    if (keyCode == UP) 
    {
      rocket.throttleUp = true;
    }
    if (keyCode == LEFT) 
    {
      rocket.turnLeft = true;
    } else if (keyCode == RIGHT) 
    {
      rocket.turnRight = true;
    }
  }
  
  if (rocket.startFreeze && key != 'r')
  {
    rocket.startFreeze = false;
  }
}

void keyReleased() 
{
  if (key == CODED) 
  {
    if (keyCode == UP) 
    {
      rocket.throttleUp = false;
    }
    if (keyCode == LEFT) 
    {
      rocket.turnLeft = false;
    } else if (keyCode == RIGHT) {
      rocket.turnRight = false;
    }
  }
}
