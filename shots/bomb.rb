require './shots/shot'
require './shots/shrapnel'

class Bomb < Shot
  def initialize(window, owner)
    super
  end
  def image_offset
    3
  end
  def team_offset
    2
  end
  def speed
    0.5
  end
  def expired?
    @detonated
  end
  def check_for_collisions! ships
    if @detonating
      ships.each do |s|
        xd = s.x - x
        yd = s.y - y
        distance = Math.sqrt(xd*xd + yd*yd)
        6.times do |i|
          if distance < i*5
            collide!(s)
          end
        end
      end
      @window.particles.add_emitter(BombEmitter.new(@x,@y,5))
      @detonated = true
    end
  end
  def collide! ship
    super
    @window.particles.add_emitter(ExplosionEmitter.new(ship.x,ship.y,30))
  end

  def detonate!(ships)
    @detonating = true
  end
  def damage
    15
  end

  def damage! *args
    @detonated = true
  end

  def move
    super
    @counter ||= 0
    @counter = (@counter + 1)%10
    @window.particles.add_emitter(SparkEmitter.new(@x, @y, 5))if @counter == 0
  end

  def ignore_hits?
    false
  end
  def deals_damage?
    false
  end
end
