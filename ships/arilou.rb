require './ships/ship'
require './weapons/light_cannon'
require './weapons/teleporter'

class Arilou < StandardShip
  def initialize(window, battle, team)
    super
    @primary = LightCannon.new(self, battle.shots)
    @secondary = Teleporter.new(self, battle.shots)
  end

  # TODO override these methods
  def self.image_offset
    0
  end
  def turn_speed
    6
  end
  def acceleration
    8
  end
  def max_velocity
    5
  end
  def move
    super
    @vel_x = 0
    @vel_y = 0
  end
  def max_hull
    (super*2/3).to_i
  end
end
