require './weapons/simple_weapon'
require './shots/slow_shot'

class SplitCannon < SimpleWeapon
  def activate! window
    shoot!(window, SlowShot, @ship.x, @ship.y, @ship.angle + 45)
    shoot!(window, SlowShot, @ship.x, @ship.y, @ship.angle - 45)
  end
  def cooldown
    35
  end
  def timer_name
    :HeavyWeapon
  end
end
