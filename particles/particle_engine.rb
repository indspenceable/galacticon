class Particle
  attr_reader :x, :y
  attr_reader :effect_id, :animation_length, :frame
  attr_accessor :z
  def initialize x, y, color, duration, effect_id = 5, animation_length = 9
    @x, @y, @color, @duration, @effect_id, @animation_length = x, y, color, duration, effect_id, animation_length
    @frame = 0
    @z = 5
  end
  def angle
    rand(360)
  end
  def tick
    @frame += 1
    @duration -= 1
  end
  def done?
    @duration <= 0
  end
  def random_color
    [0,1,2,3].sample
  end
  def color
    @color || random_color
  end
end

class ScatterParticle < Particle
  def tick
    super
    @x += rand(5)-2
    @y += rand(5)-2
  end
end
class MovingParticle < Particle
  def initialize angle, speed, *args
    super(*args)
    @angle, @speed = angle, speed
  end
  def tick
    super
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
  end
end

class StaticParticle < Particle
end

class Emitter
  attr_reader :x, :y
  def initialize(x, y, duration, color=nil)
    @x, @y, @duration, @color = x, y, duration, color
  end
  def random_color
    [0,1,2,3].sample
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

class TrailEmitter < Emitter
  def generate_particles!
      super

     [ScatterParticle.new(x, y, color, 20, 14, 1).tap{|p| p.z = 0}]
  end
end

class ExplosionEmitter < Emitter
  def generate_particles!
    super
    particles = []
    3.times do |xa|
      3.times do |ya|
        particles << MovingParticle.new(
           rand(360),
               speed,
          x + xa - 1,
          y + ya - 1,
               color,
            duration,
                   5,
                   3) if rand(chance) == 0
      end
    end
    particles
  end
  def speed
    5
  end
  def duration
    rand(10)+10
  end
  def chance
    5
  end
end

class TeleportEmitter < ExplosionEmitter
  def speed
    10
  end
  def duration
    5
  end
  def chance
    5
  end
end

class BombEmitter < ExplosionEmitter
  def speed
    2
  end
  def duration
    rand(3)+7
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
        if p.effect_id
          p.effect_id + (p.frame%p.animation_length) + p.color*20
          @window.effects[p.effect_id + (p.frame%p.animation_length) + p.color*20].draw_rot(p.x, p.y, p.z, p.angle)
        else
          @window.draw_quad(
            p.x-1, p.y-1, Player::COLORS[p.color],
            p.x+1, p.y-1, Player::COLORS[p.color],
            p.x-1, p.y+1, Player::COLORS[p.color],
            p.x+1, p.y+1, Player::COLORS[p.color]
          )
        end
    end
  end
  def any?
    @particles.any? || @emitters.any?
  end
end
