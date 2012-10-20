require './weapons/simple_weapon'

class Teleporter < SimpleWeapon
  def activate! window
    @ship.warp(rand(window.width), rand(window.height))
  end
  def cooldown
    100
  end
  def required_charge
    500
  end
end
