require './shot'

class Player
  def initialize(window)
    @w,@h = window.width, window.height
    @image = window.ship_images[image_offset]
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @shots = window.shots
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= turn_speed
  end

  def turn_right
    @angle += turn_speed
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, acceleration)
    @vel_y += Gosu::offset_y(@angle, acceleration)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= @w
    @y %= @h

    # @vel_x *= 0.95
    # @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def shoot(window)
    Shot.new(window, self).tap do |s|
      s.warp(@x, @y, @angle)
      @shots << s
    end
  end

  # TODO override these methods
  def image_offset
    rand(100)
    #15*14
  end
  def turn_speed
    4.5
  end
  def acceleration
    0.1
  end

end
