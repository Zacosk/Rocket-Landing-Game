public class Smoke
{
  float life, size;
  PVector pos;
  color colour;
  
  public Smoke(float life, PVector pos)
  {
    this.life = life;
    this.pos = new PVector(pos.x + random(-6, 6), pos.y + random(-6, 6));
    this.colour = color(random(170, 220), 200);//random(70, 120));
    this.size = random(5, 18);
  }
  
  void Draw()
  {
    noStroke();
    fill(colour, life);
    circle(pos.x, pos.y, size);
  }
  
  void Decay()
  {
    life -= 10;
    size -= 0.5;
  }
}
