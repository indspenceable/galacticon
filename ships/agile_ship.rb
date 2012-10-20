require './ships/ship'
require './weapons/light_cannon'
require './weapons/blinker'

class AgileShip < Ship
  def initialize(window, team)
    super
    @primary = LightCannon.new(self, window.shots)
    @secondary = Blinker.new(self, window.shots)
  end

  # TODO override these methods
  def self.image_offset
    61
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
