require './weapons/simple_weapon'

class ReverseThrusters < SimpleWeapon
  def activate! window
    @ship.vel_x *= 0.1
    @ship.vel_y *= 0.1
  end
  def cooldown
    15
  end
  def required_charge
    25
  end
end
