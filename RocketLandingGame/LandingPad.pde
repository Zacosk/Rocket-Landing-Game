public class LandingPad
{
  PVector startPos;
  PShape landingPad;

  public LandingPad(PVector startPos)
  {
    this.startPos = startPos;
    
    landingPad = createShape();
    landingPad.beginShape();
    landingPad.noStroke();
    landingPad.fill(180);
    landingPad.vertex(startPos.x, startPos.y);
    landingPad.vertex(startPos.x+40, startPos.y);
    landingPad.vertex(startPos.x+40, startPos.y+20);
    landingPad.vertex(startPos.x, startPos.y+20);
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
