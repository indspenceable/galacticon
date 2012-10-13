class Shot
  attr_accessor :x, :y, :angle
  def initialize(window, creator)
    @image = window.effects[image_offset]
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
    @image.draw_rot(@x, @y, 1, @angle)
  end
  def expired?
    (@ticks -= 1) <= 0
  end

  # Depends on:
  # image_offset
  # speed
  # duration

end
