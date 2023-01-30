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
    rocket.vertex(shipPos.x, shipPos.y);
    rocket.vertex(shipPos.x + 10, shipPos.y + 40);
    rocket.vertex(shipPos.x - 10, shipPos.y + 40);
    rocket.endShape(CLOSE);
  }
  
  void GenerateFlameShapes()
  {
    PShape outerFlame = createShape(TRIANGLE, 8, 15, -8, 15, 0, 30);
    //outerflame.fill(255, 0, 0);
    PShape innerFlame = createShape(TRIANGLE, 6, 15, -6, 15, 0, 20);
    //innerflame.fill(255, 165, 0);
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
    shape(rocket, -400, -300);
  
    if (throttleUp && fuel > 0)
    {
      shape(flame, 0, 0);
      /*
      fill(255, 0, 0);
      triangle(8, 15, -8, 15, 0, 30);
      fill(255, 165, 0);
      triangle(6, 15, -6, 15, 0, 20);
      */
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
      smokeTrail.add(new Smoke(255, shipPos));
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
    //IF PSHAPE CONTAINS!!!!!!!!!!!!!!!!!!!
    /*
    try
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
    catch (Exception e)
    {
      
    }*/
  }
  
  void ResetShip()
  {
    shipPos.x = width/2;
    shipPos.y = height/2;
    acceleration = 0;
    upAcceleration = 0;
    sideAcceleration = 0;
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
    rocket.ResetShip();
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
  
  if (rocket.startFreeze)
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
