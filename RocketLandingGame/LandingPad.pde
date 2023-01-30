public class LandingPad
{
  PVector endPos;
  PShape landingPad;

  public LandingPad(PVector endPos)
  {
    this.endPos = endPos;
    
    landingPad = createShape();
    landingPad.beginShape();
    landingPad.noStroke();
    landingPad.fill(180);
    landingPad.vertex(endPos.x-40, endPos.y);
    landingPad.vertex(endPos.x, endPos.y);
    landingPad.vertex(endPos.x, endPos.y+20);
    landingPad.vertex(endPos.x-40, endPos.y+20);
    landingPad.endShape(CLOSE);
  }
  
  void Draw()
  {
    shape(landingPad, 0, 0);
  }
  
  int CheckCrash(int yPos)
  {
    return 23;
    /*
    if (yPos >= pos.y && !landable)
    {
      return 1;
    } else if (yPos >= pos.y && landable)
    {
      return 2;
    }
    return 3; */
  }
}
