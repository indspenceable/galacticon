require './ships/ship'
require './weapons/light_cannon'
require './weapons/teleporter'

class Arilou < StandardShip
  def initialize(window, team)
    super
    @primary = LightCannon.new(self, window.shots)
    @secondary = Teleporter.new(self, window.shots)
  end

  # TODO override these methods
  def image_offset
    0
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
end
