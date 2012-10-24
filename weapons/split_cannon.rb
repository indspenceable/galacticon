require './weapons/simple_weapon'
require './shots/slow_shot'

class SplitCannon < SimpleWeapon
  def activate! window
    shoot!(window, SlowShot, @ship.x, @ship.y, @ship.angle + 45)
    shoot!(window, SlowShot, @ship.x, @ship.y, @ship.angle - 45)
    window.sample('missile').play
    window.delay(4, window) do |w|
      w.sample('missile').play
    end
  end
  def cooldown
    70
  end
  def timer_name
    :HeavyCannon
  end
  def required_charge
    200
  end
end
