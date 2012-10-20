require './weapons/simple_weapon'
require './shots/slow_shot'

class HeavyCannon < SimpleWeapon
  def bullet_klass
    SlowShot
  end
  def cooldown
    35
  end
  def required_charge
    200
  end
end
