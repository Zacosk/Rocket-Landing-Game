public class TerrainPoint
{
  PVector pos;
  boolean landable;
  color colour;

  public TerrainPoint(PVector pos, boolean landable)
  {
    this.pos = pos;
    this.landable = landable;
    
    colour = color(16, 36, 25);
    if (landable)
    {
      colour = color(255, 0, 0);
    }
  }
  
  void Draw()
  {
    stroke(colour);
    line(pos.x, height, pos.x, pos.y);
  }
  
  int CheckCrash(int yPos)
  {
    if (yPos >= pos.y && !landable)
    {
      return 1;
    } else if (yPos >= pos.y && landable)
    {
      return 2;
    }
    return 3;
  }
}
