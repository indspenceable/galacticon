require './ships/ship'
require './weapons/light_cannon'
require './weapons/standard_cannon'
require './weapons/reverse_thrusters'

class QuickShip < Ship
  def initialize(window, battle, team)
    super
    @primary = LightCannon.new(self, battle.shots)
    @secondary =StandardCannon.new(self, battle.shots)
    @tertiary = ReverseThrusters.new(self, battle.shots)
  end
  def max_hull
    super / 2
  end

  # TODO override these methods
  def self.image_offset
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
