require './player'
require './quick_shot'

class QuickShip < Player
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
  def shot_klass
    QuickShot
  end
end
