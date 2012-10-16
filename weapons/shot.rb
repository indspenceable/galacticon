class Shot
  attr_accessor :x, :y, :angle
  def initialize(window, owner)
    @effects = window.effects
    @owner = owner
    @w,@h = window.width, window.height
    @ticks = duration
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
    @effects[@owner.shot_offset].draw_rot(@x, @y, 1, @angle)
  end
  def expired?
    ((@ticks -= 1) <= 0) || @hit
  end
  def check_for_collisions! ships
    ships.each do |p|
      if p != @owner &&
        @x < p.x + r &&
        @x > p.x - r &&
        @y < p.y + r &&
        @y > p.y - r &&
        @hit = true
        collide!(p)
      end
    end
  end

  def collide!(p)
    p.damage!(damage)
  end
  def r
    20
  end

  # Depends on:
  # image_offset
  # speed
  # duration

end
