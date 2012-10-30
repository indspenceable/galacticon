require './shots/shot'

class GravityWell < Shot
  def initialize(window, owner)
    super
  end

  def draw
  end

  def speed
    0.5
  end

  def expired?
    timed_out?
  end

  def duration
    200
  end

  def range
    200
  end

  def check_for_collisions! ships
    ships.each do |s|
      next if s == @owner
      xd = s.x - x
      yd = s.y - y
      distance = Math.sqrt(xd*xd + yd*yd)
      if distance < range
        pull!(s, distance)
      end
    end
  end
  def pull! ship, distance
    xd = x - ship.x
    yd = y - ship.y
    denom = distance*distance
    denom = 0.5 if denom < 0.5
    ship.vel_x += xd/denom
    ship.vel_y += yd/denom
    # ship.warp(ship.x + xd/(denom), ship.y + yd/(denom))
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
    true
  end
  def deals_damage?
    false
  end
end
