class Shot
  attr_accessor :x, :y, :angle
  def initialize(window, owner)
    @effects = window.effects
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
    @effects[image_offset + team_offset*@owner.team].draw_rot(@x, @y, 1, @angle)
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
        collide!(p)
      end
    end
  end
  def team_offset
    8
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
