public class Smoke
{
  float life, size;
  PVector pos;
  color colour;
  
  public Smoke(float life, PVector pos)
  {
    this.life = life;
    this.pos = new PVector(pos.x + random(-10, 10), pos.y + random(-10, 10));
    this.colour = color(random(70, 120));
    this.size = random(10, 25);
  }
  
  void Draw()
  {
    fill(colour, life);
    circle(pos.x, pos.y, size);
  }
  
  void Decay()
  {
    life -= 10;
    size -= 0.5;
  }
}
