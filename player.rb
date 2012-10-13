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
    shot_klass.new(window, self).tap do |s|
      s.warp(@x, @y, @angle)
      @shots << s
    end
  end

  # DEPENDS ON:
  # image_offset
  # turn_speed
  # acceleration
  # shot_klass
end
