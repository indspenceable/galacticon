require './weapons/simple_weapon'

class ReverseThrusters < SimpleWeapon
  def activate! window
    @ship.vel_x *= -1
    @ship.vel_y *= -1
    @ship.angle +=  180
  end
  def cooldown
    15
  end
  def required_charge
    25
  end
end
