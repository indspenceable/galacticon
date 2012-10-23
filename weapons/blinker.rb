require './weapons/simple_weapon'

class Blinker < SimpleWeapon
  BLINK_DISTANCE = 250
  def activate! window
    window.particles.add_emitter(TeleportEmitter.new(@ship.x, @ship.y, 5, @ship.color))
    @ship.warp(@ship.x + Gosu::offset_x(@ship.angle, BLINK_DISTANCE),
               @ship.y + Gosu::offset_y(@ship.angle, BLINK_DISTANCE))

  end
  def cooldown
    50
  end
  def required_charge
    100
  end
end
