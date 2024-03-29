require './ships/ship'
require './weapons/heavy_cannon'
require './weapons/split_cannon'

class StandardShip < Ship
  def initialize(window, battle, team)
    super
    @primary = HeavyCannon.new(self, battle.shots)
    @secondary = SplitCannon.new(self, battle.shots)
  end
  def self.image_offset
    1
  end
  def turn_speed
    3.5
  end
  def acceleration
    0.1
  end
  def max_velocity
    9.0
  end
end
