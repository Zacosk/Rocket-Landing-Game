public class LandingPad
{
  PVector startPos;
  PShape landingPad, landingStalk;

  public LandingPad(PVector startPos)
  {
    this.startPos = startPos;
    
    landingPad = createShape();
    landingPad.beginShape();
    landingPad.noStroke();
    landingPad.fill(180);
    landingPad.vertex(startPos.x, startPos.y-15);
    landingPad.vertex(startPos.x+40, startPos.y-15);
    landingPad.vertex(startPos.x+35, startPos.y-7);
    landingPad.vertex(startPos.x+5, startPos.y-7);
    landingPad.endShape(CLOSE);
    
    landingStalk = createShape();
    landingStalk.beginShape();
    landingStalk.noStroke();
    landingStalk.fill(120);
    landingStalk.vertex(startPos.x+30, startPos.y-7);
    landingStalk.vertex(startPos.x+30, startPos.y+20);
    landingStalk.vertex(startPos.x+10, startPos.y+20);
    landingStalk.vertex(startPos.x+10, startPos.y-7);
    landingStalk.endShape(CLOSE);
  }
  
  void Draw()
  {
    shape(landingPad, 0, 0);
    shape(landingStalk, 0, 0);
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
