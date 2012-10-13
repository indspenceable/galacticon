require './player'
require './quick_shot'

class Arilou < StandardShip
  # TODO override these methods
  def image_offset
    1
  end
  def turn_speed
    6
  end
  def acceleration
    8
  end
  def max_velocity
    9.0
  end
  def move
    super
    @vel_x = 0
    @vel_y = 0
  end
  def action1(window)
    shoot(window,QuickShot)
  end
  def action2(window)
    warp(rand(@w), rand(@h))
  end
end
