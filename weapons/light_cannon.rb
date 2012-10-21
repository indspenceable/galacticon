require './weapons/simple_weapon'
require './shots/quick_shot'

class LightCannon < SimpleWeapon
  def bullet_klass
    QuickShot
  end
  def activate! window
    shoot!(window, bullet_klass, @ship.x, @ship.y, @ship.angle + rand(15) - 7)
  end
  def cooldown
    5
  end
  def required_charge
    12
  end
end
