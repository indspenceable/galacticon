require './player'
require './slow_shot'

class StandardShip < Player
  # TODO override these methods
  def image_offset
    1
  end
  def turn_speed
    4.5
  end
  def acceleration
    0.1
  end
  def shot_klass
    SlowShot
  end
end
