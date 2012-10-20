require './weapons/simple_weapon'

class Blinker < SimpleWeapon
  BLINK_DISTANCE = 100
  def activate! window
    @ship.warp(@ship.x + Gosu::offset_x(@ship.angle, BLINK_DISTANCE),
               @ship.y + Gosu::offset_y(@ship.angle, BLINK_DISTANCE))

  end
  def cooldown
    100
  end
  def required_charge
    250
  end
end
