public class ParticleGenerator {
  int max_particles;
  int num_particles;
  float duration;
  int gen_rate;
  Vec2 p_pos[];
  Vec2 p_vel[];
  float p_life[];
  Vec2 source_pos;
  
  public ParticleGenerator(int max_particles, int gen_rate, float duration, Vec2 source_pos) {
    this.max_particles = max_particles;
    this.num_particles = 0;
    this.duration = duration;
    this.gen_rate = gen_rate;
    this.p_pos = new Vec2[max_particles];
    this.p_vel = new Vec2[max_particles];
    this.p_life = new float[max_particles];
    this.source_pos = source_pos;
  }
  
  
  //generator code based of a solution from Professor Stephen Guy's ParticleSystem 
  public void drawExplosion(float dt) {
    float to_gen_f = gen_rate * dt;
    int to_gen = int(to_gen_f);
    float fract_part = to_gen_f - to_gen;
    if (random(1) < fract_part) to_gen += 1;
    for (int i = 0; i < to_gen; i++){
      if (num_particles >= max_particles) break;
      p_pos[num_particles] = new Vec2(random(-1,1),random(-1,1));
      p_vel[num_particles] = new Vec2(random(-100,100),random(-100,100));
      p_life[num_particles] = duration;
      num_particles += 1;
    }
    
      for (int i = 0; i <  num_particles; i++){
        p_life[i] -= dt; //reduce lifetime;
        if (p_life[i] <= 0) { //kill the particle if its life is up
          float tempLife = p_life[num_particles-1];
          Vec2 tempPos = p_pos[num_particles-1];
          Vec2 tempVel = p_vel[num_particles-1];
          
          p_life[num_particles-1] = p_life[i]; //swap the last particle element with this one
          p_pos[num_particles-1] = p_pos[i];
          p_vel[num_particles-1] = p_vel[i];
          
          p_life[i] = tempLife;
          p_pos[i] = tempPos;
          p_vel[i] = tempVel;
          
          num_particles-=1; //shrink the number of existing particles
          max_particles-=1;
        }
        //continue on calculating the last particle
        
        p_pos[i].add(p_vel[i].times(dt)); //Update position based on velocity
        
        //draw explosion particle
        circle(source_pos.x + p_pos[i].x, source_pos.y + p_pos[i].y, 2);
      }
  }
}
