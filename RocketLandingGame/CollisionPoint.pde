public class CollisionPoint {
  PVector pos;
  color colour;
  
  public CollisionPoint(PVector pos)
  {
    this.pos = pos;
  }
  
  public boolean CheckCollision(PVector shipPos)
  {
    if (shipPos.x < pos.x - 20 || shipPos.x > pos.x+20)
    {
      colour = color(255, 0, 0);
      return false;
    }
    colour = color(0, 255, 0);
    if (rocket.rocket.contains(pos.x-shipPos.x, pos.y-(shipPos.y-50)))
    {
      colour = color(0, 0, 255);
      return true;
    }
    return false;
  }
  
  public void DrawDebug()
  {
    fill(colour);
    circle(pos.x, pos.y, 5);
  }
}
