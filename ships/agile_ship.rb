require './ships/ship'
require './weapons/standard_cannon'
require './weapons/blinker'

class AgileShip < Ship
  def initialize(window, battle, team)
    super
    @primary = StandardCannon.new(self, battle.shots)
    @secondary = Blinker.new(self, battle.shots)
  end

  # TODO override these methods
  def self.image_offset
    61
  end
  def turn_speed
    9
  end
  def acceleration
    0.1
  end
  def max_velocity
    4
  end
end
