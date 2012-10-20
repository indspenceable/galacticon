require './weapons/simple_weapon'
require './shots/slow_shot'

class SplitCannon < SimpleWeapon
  def activate! window
    shoot!(window, SlowShot, @ship.x, @ship.y, @ship.angle + 45)
    shoot!(window, SlowShot, @ship.x, @ship.y, @ship.angle - 45)
  end
  def cooldown
    70
  end
  def timer_name
    :HeavyCannon
  end
end
