public class Rocket
{
  int maxDistance;
  float fuel, backFuel, acceleration, upAcceleration, sideAcceleration, rotation, rotationSpeed, speed, landingSpeed, maxUpAcceleration, maxSideAcceleration, maxXVelocity, maxYVelocity, flameSize;
  PVector shipPos, oldPos, velocity;
  boolean throttleUp, turnLeft, turnRight;
  ArrayList<Smoke> smokeTrail = new ArrayList<Smoke>();
  PShape rocket, flame;
  
  public Rocket(color col)
  {
    shipPos = new PVector(width/2, 160);
    velocity = new PVector(0, 0);
  
    rotationSpeed = 0.1;
    fuel = 100;
    backFuel = fuel;
    
    gravity = 0.15;
    landingSpeed = 0.05f;
    maxUpAcceleration = 0.0025;
    maxSideAcceleration = 0.002;
    maxXVelocity = 0.3;
    maxYVelocity = 0.2;
    
    maxDistance = 500;
    flameSize = 1;
    
    flame = createShape(GROUP);
    
    GenerateRocketShape(col);
    GenerateFlameShapes();
  }
  
  void GenerateRocketShape(color col)
  {
    rocket = createShape();
    rocket.beginShape();
    rocket.noStroke();
    rocket.fill(col);
    rocket.vertex(0, 0);
    rocket.vertex(10, 50);
    rocket.vertex(0, 45);
    rocket.vertex(-10, 50);
    rocket.endShape(CLOSE);
  }
  
  void GenerateFlameShapes()
  {
    PShape outerFlame = createShape(TRIANGLE, 9, 10, -9, 10, 0, 22);
    outerFlame.setFill(color(255, 0, 0, 200));
    outerFlame.setStroke(false);
    PShape innerFlame = createShape(TRIANGLE, 5, 10, -5, 10, 0, 17);
    innerFlame.setFill(color(255, 165, 0, 200));
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
    //Draw text
    if (gameState == GameStates.Playing)
    {
      fill(255);
      if (velocity.y > landingSpeed)
      {
        fill(255, 0, 0);
      }
      textSize(20);
      textAlign(RIGHT);
      text(Integer.toString((int)(speed*1000)), 43, -35);
      textAlign(LEFT);
      textSize(15);
      text("m/s", 45, -35);
    }
    
    rotate(radians(rotation));
  
    
    push();
    if (throttleUp && fuel > 0 && gameState == GameStates.Playing)
    {
      if ((int)deltaTime % 2 == 0)
      {
        smokeTrail.add(new Smoke(255, new PVector((float)(shipPos.x+ 15* Math.cos(radians(rotation+90))), (float)(shipPos.y+15*Math.sin(radians(rotation+90))))));
        flameSize = random(1, 2);
      }
      scale(1, flameSize);
      shape(flame, 0, -14);
    }
    pop();
    shape(rocket, 0, -50);
    popMatrix();
  }
  
  void DrawFuel()
  {
    int drawPos = (width/2)-200;
    rectMode(CORNER);
    if (!FuelEmpty(backFuel)) {
      fill(255, 0, 0);
      rect(drawPos, 50, map(backFuel, 0, 100, 0, 400), 20);
    }
    if (!FuelEmpty(fuel)) {
      fill(255);
      rect(drawPos, 50, map(fuel, 0, 100, 0, 400), 20);
    }
  }
  
  boolean FuelEmpty(float num)
  {
    if (num > 0) {
      return false;
    }
    return true;
  }
  
  void Move()
  {
    CalculateDeltaTime();
  
    if (throttleUp && fuel >= 0)
    { 
      
      acceleration = 1;
      fuel -= 0.1;
      backFuel -= 0.05;
    } else {
      acceleration = 0;
      backFuel -= 0.2;
      velocity.y += gravity * deltaTime * 0.001;
    }
    backFuel = constrain(backFuel, fuel, backFuel);
    
    acceleration = constrain(acceleration, 0, 0.6);
    
    float upVelocityComponent = GetAccelerationComponent(rotation);
  
    upAcceleration = acceleration * upVelocityComponent * GetAccelerationDirection(rotation, true);
    sideAcceleration = (acceleration * 0.01) * (1-upVelocityComponent) * GetAccelerationDirection(rotation, false);
  
    sideAcceleration = constrain(sideAcceleration, maxSideAcceleration*-1, maxSideAcceleration);
    upAcceleration = constrain(upAcceleration, maxUpAcceleration*-1, maxUpAcceleration);
    
    velocity.x += sideAcceleration;
    velocity.y -= upAcceleration;
    
    velocity.x = constrain(velocity.x, maxXVelocity * -1, maxXVelocity);
    velocity.y = constrain(velocity.y, maxYVelocity * -1, 3);
    
    //main movement calculation
    oldPos = new PVector(shipPos.x, shipPos.y);
    shipPos.y += (velocity.y)*deltaTime;
    
    shipPos.x += velocity.x * deltaTime;
    speed = shipPos.dist(oldPos)/deltaTime;

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
    //Detect if ship is outside of bounds
    if (shipPos.x > width+maxDistance || shipPos.x < 0 - maxDistance || shipPos.y < 0 - maxDistance)
    {
      ResetShip();
    }
    
    //Detect if ship is on or below terrain
    if (CheckTerrainCollision() || shipPos.y > height)
    {
      if (fuel <= 0) {
        gameState = GameStates.Lost;
      } else {
        ResetShip();
      }
      
      //Detect if ship is on landing pad
    } else if (landingPad.landingPad.contains(shipPos.x, shipPos.y))
    {
      if (velocity.y > landingSpeed)
      {
        ResetShip();
        return;
      }
      gameState = GameStates.Won;
    }
  }
  
  void ResetShip()
  {
    shipPos.x = width/2;
    shipPos.y = 160;
    acceleration = 0;
    velocity.x = 0;
    velocity.y = 0;
    rotation = 0;
    upAcceleration = 0;
    sideAcceleration = 0;
    fuel -= 10;
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
  
  int GetAccelerationDirection(float rotation, boolean up)
  {
    if (up)
    {
      if (rotation >= 270 && rotation <= 90)
      {
        return -1;
      } else {
        return 1;
      }
    } else {
      if (rotation >= 0 && rotation <= 180)
      {
        return 1;
      } else {
        return -1;
      }
    }
  }
  
  float GetAccelerationComponent(float rotation)
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
    return 1;
  }
  
  void PrintDebug()
  {
    println("========ShipStats========");
    println("Pos - X: " + shipPos.x + ", Y: " + shipPos.y);
    println("Accl - up: " + upAcceleration + ", side: " + sideAcceleration);
    println("vel - y: " + velocity.y + ", x: " + velocity.x);
    println("up calc:" + (gravity + velocity.y) + ", grav: " + gravity);
    println("accl:" + acceleration + " speed: " + speed + " * v comp:" + GetAccelerationComponent(rotation) + " = " + sideAcceleration);  
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
      if (gameState == GameStates.Start) {
        gameState = GameStates.Playing;
        oldMillis = millis();
      }
    }
    if (keyCode == LEFT) 
    {
      rocket.turnLeft = true;
    } else if (keyCode == RIGHT) 
    {
      rocket.turnRight = true;
    }
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
