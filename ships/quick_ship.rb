require './ships/ship'
require './weapons/quick_shot'

class QuickShip < Ship
  # TODO override these methods
  def image_offset
    60
  end
  def turn_speed
    6
  end
  def acceleration
    0.3
  end
  def action1(window)
    shoot(window,QuickShot)
  end
  def action2(window)
    @vel_x *= -0.5
    @vel_y *= -0.5
    @angle += 180
  end
  def max_velocity
    6.0
  end
end
