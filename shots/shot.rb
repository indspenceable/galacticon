class Shot
  attr_accessor :x, :y, :angle
  def initialize(window, owner)
    @owner = owner
    @w,@h = window.width, window.height
    @window = window
  end
  def warp(x, y, angle)
    self.x = x
    self.y = y
    self.angle = angle
  end
  def move
    @x += Gosu::offset_x(@angle, speed)
    @y += Gosu::offset_y(@angle, speed)
    @x %= @w
    @y %= @h
  end
  def draw
    @window.effects[image_offset + @owner.color*20].draw_rot(@x, @y, 10, @angle)
  end
  def hit?
    !!@hit
  end
  def timed_out?
    @ticks ||= duration
    ((@ticks -= 1) <= 0)
  end

  def team
    @owner.team
  end

  def expired?
    timed_out? || hit?
  end
  def check_for_collisions! ships
    ships.each do |p|
      if p.team != team &&
        @x < p.x + r &&
        @x > p.x - r &&
        @y < p.y + r &&
        @y > p.y - r &&
        @hit = true
        display_emitters!
        play_sound!
        collide!(p)
      end
    end
  end
  def display_emitters!
    @window.particles.add_emitter(SparkEmitter.new(@x, @y, 5, @owner.color))
  end
  def play_sound!
    @window.sample("hit2").play
  end

  def collide!(ship)
    ship.damage!(damage)
  end
  def r
    20
  end

  def ignore_hits?
    true
  end
  def deals_damage?
    true
  end
end
