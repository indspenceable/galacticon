class Particle
  attr_reader :x, :y, :color
  def initialize x, y, color, duration
    @x, @y, @color, @duration = x, y, color, duration
  end
  def tick
    @duration -= 1
  end
  def done?
    @duration <= 0
  end
end

class ScatterParticle < Particle
  def tick
    super
    @x += rand(5)-2
    @y += rand(5)-2
  end
end

class StaticParticle < Particle
end
# class MovingParticle < Particle
#   def initialize x, y, color, duration, vel_x, vel_y
#     super(x,y,color,duration)
#     @vel_x, @vel_y= vel_x, vel_y
#   end
#   def tick
#     super
#     @x += @vel_x
#     @y += @vel_y
#   end
# end

class Emitter
  attr_reader :x, :y
  def initialize(x, y, duration, color=nil)
    @x, @y, @duration, @color = x, y, duration, color
  end
  def random_color
    [
      Gosu::Color::RED,
      Gosu::Color::BLUE,
      Gosu::Color::GREEN,
      Gosu::Color::YELLOW
    ].sample
  end
  def color
    @color || random_color
  end
  def generate_particles!
     @duration -= 1
  end
  def done?
    @duration <= 0
  end
end

class SparkEmitter < Emitter
  def generate_particles!
      super
     [ScatterParticle.new(x, y, color, 20)]*3
  end
end

class ExplosionEmitter < Emitter
  def generate_particles!
    super
    particles = []
    3.times do |xa|
      3.times do |ya|
        particles << ScatterParticle.new(x + xa - 1, y + ya - 1, color, 20) if rand(2) == 0
      end
    end
    particles
  end
end

class BombEmitter < Emitter
  def generate_particles!
    super
    particles = []
    3.times do |xa|
      3.times do |ya|
        particles << ScatterParticle.new(x + (xa - 1)*15, y + (ya - 1)*15, color, 2)
        if xa == 1 || ya == 1
          particles << ScatterParticle.new(x + (xa - 1)*30, y + (ya - 1)*30, color, 2)
        end
      end
    end
    particles
  end
end

class ParticleEngine
  def initialize(window)
    @window = window
    @emitters = []
    @particles = []
  end
  def add_emitter e
    @emitters << e
  end
  def tick
    @emitters.reject! do |e|
      @particles += e.generate_particles!
      e.done?
    end
    @particles.reject! do |p|
      p.tick
      p.done?
    end
  end
  def draw
    @particles.each do |p|
      @window.draw_quad(
        p.x-1, p.y-1, p.color,
        p.x+1, p.y-1, p.color,
        p.x-1, p.y+1, p.color,
        p.x+1, p.y+1, p.color
      )
    end
  end
end
