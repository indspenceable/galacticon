require './ship'
require './slow_shot'

class StandardShip < Ship
  def image_offset
    1
  end
  def turn_speed
    4.5
  end
  def acceleration
    0.1
  end
  def action1(window)
    shoot(window,SlowShot)
  end
  def action2(window)
    shoot(window,SlowShot, @x+Gosu::offset_x(@angle+90,  10), @y+Gosu::offset_y(@angle+90,  10))
    shoot(window,SlowShot, @x+Gosu::offset_x(@angle+90, -10), @y+Gosu::offset_y(@angle+90, -10))
  end
  def max_velocity
    8.0
  end
end
