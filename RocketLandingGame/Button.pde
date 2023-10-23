public class Button
{
  String text;
  PVector position, size;
  public boolean hover, selected;
  
  public Button(String text, PVector position, PVector size)
  {
    this.text = text;
    this.position = position;
    this.size = size;
  }
  
  public void Run()
  {
    Draw();
    CheckHover();
  }
  
  public void Draw()
  {
    push();
    translate(position.x, position.y);
    
    fill(rocketCol);
    strokeWeight(2);
    stroke(rocketCol);
    
    Display(rocketCol, rocketCol, false);
    if (hover)
    {
      Display(color(red(rocketCol) - 100, green(rocketCol) - 100, blue(rocketCol) - 100), rocketCol, false);
    }
    
    if (selected)
    {
      Display(backgroundCol, rocketCol, true);
    }
    

    pop();
  }
  
  void Display(color textCol, color btnFill, boolean fill)
  {
    if (!fill)
    {
      noFill();
      stroke(textCol);
    } else {
      stroke(btnFill);
      fill(btnFill);
    }
    rectMode(CENTER);
    rect(0, 0, size.x, size.y, 5);
    
    fill(textCol);
    strokeWeight(2);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(text, 0, 0);
  }
  
  public void CheckHover()
  {
    hover = false;
    if (mouseX <= position.x + (size.x/2) && mouseX >= position.x - (size.x/2))
    {
      if (mouseY <= position.y + (size.y/2) && mouseY >= position.y - (size.y/2))
      {
        hover = true;
      }
    }
  }
}
