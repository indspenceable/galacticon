require './weapons/simple_weapon'

class Teleporter < SimpleWeapon
  def activate! window
    window.particles.add_emitter(TeleportEmitter.new(@ship.x, @ship.y, 5, @ship.color))
    @ship.warp(rand(window.width), rand(window.height))
  end
  def cooldown
    100
  end
  def required_charge
    250
  end
end
