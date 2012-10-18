require './weapons/simple_weapon'

class ReverseThrusters < SimpleWeapon
  def activate! window
    @ship.vel_x *= -0.5
    @ship.vel_y *= -0.5
    @ship.angle +=  180
  end
end
