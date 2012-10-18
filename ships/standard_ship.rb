require './ships/ship'
require './weapons/heavy_cannon'

class StandardShip < Ship
  def initialize(window, team)
    super
    @primary = @secondary = HeavyCannon.new(self, window.shots)
    #@secondary = HeavyCannon.new(self, window.shots)
  end
  def image_offset
    1
  end
  def turn_speed
    4.5
  end
  def acceleration
    0.1
  end
  def max_velocity
    8.0
  end
end
