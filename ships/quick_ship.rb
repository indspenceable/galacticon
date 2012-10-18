require './ships/ship'
require './weapons/light_cannon'
require './weapons/reverse_thrusters'

class QuickShip < Ship
  def initialize(window, team)
    super
    @primary = LightCannon.new(self, window.shots)
    @secondary = ReverseThrusters.new(self)
  end

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
  def max_velocity
    6.0
  end
end
